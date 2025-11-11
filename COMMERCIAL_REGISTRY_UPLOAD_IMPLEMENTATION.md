# Commercial Registry Upload Implementation

## ✅ Completed

### 1. Database Schema
- ✅ Added `commercialRegistryUrl` field to `Bakery` model in `prisma/schema.prisma`
- **Location:** `khubzati_api_project 2/prisma/schema.prisma`

### 2. Backend File Upload Endpoint
- ✅ Created `/upload/document` endpoint
- ✅ Added multer for file handling
- ✅ Supports single and multiple file uploads
- ✅ File validation (images and PDFs, max 10MB)
- ✅ Files stored in `uploads/` directory
- **Location:** `khubzati_api_project 2/src/routes/upload.js`
- **Package:** Added `multer` to `package.json`

### 3. Backend Bakery Registration
- ✅ Updated `POST /bakeries` to accept `commercialRegistryUrl`
- ✅ Stores `commercialRegistryUrl` in database
- **Location:** `khubzati_api_project 2/src/routes/bakeries.js`

### 4. Mobile App - API Client
- ✅ Added upload endpoints to `ApiConstants`
- ✅ Fixed `uploadFiles` method to use 'file' for single upload
- **Location:** `lib/core/api/api_constants.dart`, `lib/core/api/api_client.dart`

### 5. Mobile App - Auth Service
- ✅ Added `uploadFile` method
- ✅ Updated `registerBakery` to accept `commercialRegistryUrl`
- **Location:** `lib/features/auth/data/services/auth_service.dart`

### 6. Mobile App - Auth Bloc
- ✅ Implemented `_onFileUploadRequested` handler
- ✅ Updated `_onBakeryRegistrationRequested` to include `commercialRegistryUrl`
- ✅ Added `FileUploadRequested` event handler
- **Location:** `lib/features/auth/application/blocs/auth_bloc.dart`

### 7. Mobile App - Events
- ✅ Added `commercialRegistryUrl` to `BakeryRegistrationRequested` event
- **Location:** `lib/features/auth/application/blocs/auth_event.dart`

---

## ⚠️ Remaining Work

### 1. Mobile App - File Upload Integration (IN PROGRESS)

**Current State:**
- Files are selected but NOT uploaded
- Only filename is stored, not file URL
- Upload needs to be triggered when file is selected

**Required Changes:**

#### Update `personal_info_step.dart`:
```dart
// Store file paths and URLs
String? _commercialRegistryFilePath;
String? _commercialRegistryFileUrl;
String? _logoFilePath;
String? _logoFileUrl;

// In onFileSelected callback:
onFileSelected: (path, name) {
  setState(() {
    _selectedCommercialRegistryFileName = name;
    _commercialRegistryFilePath = path;
  });
  
  // Trigger file upload
  context.read<AuthBloc>().add(
    FileUploadRequested(
      filePath: path,
      fileName: name,
      uploadType: 'commercial_registry',
    ),
  );
  
  _updateFormData();
}

// Listen to FileUploadSuccess state
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is FileUploadSuccess) {
      if (state.uploadType == 'commercial_registry') {
        setState(() {
          _commercialRegistryFileUrl = state.fileUrl;
        });
        _updateFormData();
      } else if (state.uploadType == 'logo') {
        setState(() {
          _logoFileUrl = state.fileUrl;
        });
        _updateFormData();
      }
    } else if (state is FileUploadError) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: ...,
)
```

#### Update `_updateFormData()`:
```dart
void _updateFormData() {
  final data = {
    'bakeryName': _bakeryNameController.text,
    'location': _locationController.text,
    'phone': _phoneNumber ?? _phoneController.text,
    'commercialRegistry': _commercialRegistryFileUrl, // Store URL, not filename
    'logo': _logoFileUrl, // Store URL, not filename
  };
  widget.onDataChanged(data);
  _validateForm();
}
```

#### Update `signup_screen.dart` bakery registration:
```dart
// In _onOtpVerificationRequested handler
await authService.registerBakery(
  name: bakeryName,
  addressLine1: location,
  city: location,
  phoneNumber: phoneNumber,
  email: email,
  logoUrl: pendingBakeryData['logo']?.toString(), // Now contains URL
  commercialRegistryUrl: pendingBakeryData['commercialRegistry']?.toString(), // Now contains URL
  description: pendingBakeryData['description']?.toString(),
);
```

---

### 2. Admin Interface - Display Commercial Registry

**Required Changes:**

#### Update `admin/src/app/vendors/[id]/page.tsx`:
```typescript
// Add commercial registry display section
{vendor.commercialRegistryUrl && (
  <Card variant="elevated">
    <h2 className="text-xl font-semibold mb-4">
      Commercial Registry Document
    </h2>
    <div className="space-y-3">
      <a
        href={vendor.commercialRegistryUrl}
        target="_blank"
        rel="noopener noreferrer"
        className="text-primary-600 hover:text-primary-700 underline"
      >
        View Commercial Registry Document
      </a>
    </div>
  </Card>
)}
```

#### Update Vendor type/interface:
```typescript
// In domain/entities/Vendor.ts
export interface Vendor {
  // ... existing fields
  commercialRegistryUrl?: string;
}
```

#### Update admin API response:
- Ensure `GET /admin/vendors/:id` returns `commercialRegistryUrl`
- Already included if using Prisma query

---

### 3. Database Migration

**Required:**
```bash
cd khubzati_api_project\ 2
npx prisma migrate dev --name add_commercial_registry_url
npx prisma generate
```

---

## 🧪 Testing Checklist

### Backend:
- [ ] Install multer: `npm install` in backend directory
- [ ] Run migration: `npx prisma migrate dev`
- [ ] Test file upload endpoint: `POST /v1/upload/document`
- [ ] Test bakery registration with `commercialRegistryUrl`
- [ ] Verify file is stored in `uploads/` directory
- [ ] Verify `commercialRegistryUrl` is saved in database

### Mobile App:
- [ ] Select commercial registry file
- [ ] Verify file upload is triggered
- [ ] Verify `FileUploadSuccess` state is emitted
- [ ] Verify file URL is stored in form data
- [ ] Complete signup flow
- [ ] Verify `commercialRegistryUrl` is sent to backend
- [ ] Verify bakery is created with document URL

### Admin Interface:
- [ ] View pending vendor
- [ ] Verify commercial registry document is displayed
- [ ] Verify document link works
- [ ] Approve/reject vendor
- [ ] Verify document is still accessible after rejection

---

## 📝 Next Steps

1. **Complete mobile app file upload integration** (Priority 1)
   - Update `personal_info_step.dart` to trigger uploads
   - Store file URLs instead of filenames
   - Update signup flow to use URLs

2. **Run database migration** (Priority 1)
   - Create and run Prisma migration

3. **Update admin interface** (Priority 2)
   - Display commercial registry document
   - Add download/view functionality

4. **Test complete flow** (Priority 2)
   - End-to-end testing from signup to admin approval

---

## 🔧 Installation Instructions

### Backend:
```bash
cd "khubzati_api_project 2"
npm install
npx prisma migrate dev --name add_commercial_registry_url
npx prisma generate
npm run start:dev
```

### Mobile App:
- No additional packages needed
- Files already use Dio for HTTP requests

---

**Last Updated:** December 2024

