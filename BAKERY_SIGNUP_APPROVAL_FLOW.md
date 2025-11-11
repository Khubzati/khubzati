# Complete Bakery Signup & Approval Flow Analysis

## 📋 Overview

This document traces the complete flow from bakery owner signup through admin approval/rejection, including login restrictions and document handling.

---

## 🔄 Complete Flow Diagram

```
1. SIGNUP (Mobile App)
   ↓
2. Phone Verification (Firebase OTP)
   ↓
3. User Registration (Backend)
   ↓
4. Bakery Registration (Backend) → status: 'pending_approval'
   ↓
5. Admin Reviews Application
   ├─→ APPROVE → status: 'approved', user.isVerified: true
   └─→ REJECT → status: 'rejected', user.isVerified: false
   ↓
6. LOGIN ATTEMPT
   ├─→ Approved → ✅ Login Success
   ├─→ Pending → ❌ Blocked (403 error)
   └─→ Rejected → ❌ Blocked (403 error)
```

---

## 📱 Step 1: Mobile App - Signup Flow

### Location: `lib/features/auth/presentation/screens/signup_screen.dart`

**Process:**

1. **User Fills Signup Form:**
   - Personal info (name, phone, email)
   - Bakery info (bakery name, location, description)
   - **Documents uploaded:**
     - Commercial Registry (via `LabeledFileUpload`)
     - Bakery Logo (via `LabeledFileUpload`)
   - Password

2. **Phone Verification:**
   ```dart
   // Firebase Phone Auth
   await FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber: formattedPhone,
     codeSent: (verificationId, resendToken) {
       // Navigate to OTP screen
     }
   );
   ```

3. **OTP Verification:**
   - User enters OTP code
   - Firebase verifies OTP
   - After verification, proceed to backend registration

4. **Backend Registration:**
   ```dart
   // Store bakery data temporarily
   await appPreferences.setPendingBakeryData({
     'bakeryName': data['bakeryName'],
     'location': data['location'],
     'phone': phone,
     'email': email,
     'logo': data['logo'],  // File URL after upload
     'description': data['description'],
   });
   
   // Register user first
   context.read<AuthBloc>().add(SignupRequested(...));
   ```

5. **After User Registration:**
   ```dart
   // In AuthBloc._onOtpVerificationRequested
   if (userRole == 'bakery_owner') {
     final pendingBakeryData = await appPreferences.getPendingBakeryData();
     
     // Register bakery with backend
     await authService.registerBakery(
       name: bakeryName,
       addressLine1: location,
       logoUrl: pendingBakeryData['logo'],
       // ... other fields
     );
   }
   ```

**Files Involved:**
- `signup_screen.dart` - Main signup screen
- `step_based_signup.dart` - Multi-step form
- `personal_info_step.dart` - Personal info + document uploads
- `auth_bloc.dart` - Handles registration logic

---

## 🔧 Step 2: Backend - User Registration

### Location: `khubzati_api_project 2/src/routes/auth.js`

**Endpoint:** `POST /auth/register`

**Process:**

1. **User Created:**
   ```javascript
   const user = await prisma.user.create({
     data: {
       username,
       email,
       password: hashedPassword,
       phoneNumber,
       role: 'bakery_owner',
       isVerified: false,  // Not verified until bakery approved
     }
   });
   ```

2. **Response:**
   - Returns user data + JWT token
   - User can authenticate but cannot login (blocked by vendor eligibility check)

**Status:** ✅ User account created, but `isVerified: false`

---

## 🏪 Step 3: Backend - Bakery Registration

### Location: `khubzati_api_project 2/src/routes/bakeries.js`

**Endpoint:** `POST /bakeries` (requires authentication)

**Process:**

1. **Bakery Created:**
   ```javascript
   const bakery = await prisma.bakery.create({
     data: {
       name,
       description,
       addressLine1,
       city,
       phoneNumber,
       email,
       logoUrl,        // Logo file URL
       coverImageUrl,  // Cover image URL
       status: 'pending_approval',  // ⚠️ Starts as pending
       ownerId: req.user.id,
     }
   });
   ```

2. **Response:**
   ```json
   {
     "status": "success",
     "data": {
       "bakery": {
         "id": "...",
         "status": "pending_approval",
         ...
       }
     }
   }
   ```

**Status:** ✅ Bakery created with `status: 'pending_approval'`

**⚠️ CRITICAL ISSUE FOUND:** 
- Commercial Registry document is **selected** in mobile app but **NEVER uploaded to server**
- File upload handler (`FileUploadRequested` event) exists but **NOT implemented in AuthBloc**
- Only filename is stored in form data, file is never sent to backend
- Backend only receives `logoUrl` and `coverImageUrl` (URLs, not files)
- **Commercial Registry is completely lost** - not stored anywhere

---

## 👨‍💼 Step 4: Admin - Review Application

### Location: `admin/src/app/vendors/[id]/page.tsx`

**Admin Interface:**

1. **View Pending Vendors:**
   - Admin navigates to `/vendors`
   - Sees list of vendors with `status: 'pending_approval'`
   - Can filter by status, type, etc.

2. **View Vendor Details:**
   - Click on vendor to see full details
   - Shows:
     - Bakery information
     - Owner information
     - Logo (if uploaded)
     - Cover image (if uploaded)
     - **⚠️ Commercial Registry NOT displayed** (not stored)

3. **Approve Vendor:**
   ```typescript
   // Admin clicks "Approve" button
   await approveVendor(vendorId);
   
   // Backend: PUT /admin/vendors/:id/approve
   ```

4. **Reject Vendor:**
   ```typescript
   // Admin clicks "Reject" button
   // Enters rejection reason
   await rejectVendor(vendorId, rejectionReason);
   
   // Backend: PUT /admin/vendors/:id/reject
   ```

---

## ✅ Step 5: Backend - Approval Process

### Location: `khubzati_api_project 2/src/routes/admin.js`

**Endpoint:** `PUT /admin/vendors/:id/approve`

**Process:**

1. **Find Vendor:**
   ```javascript
   let vendor = await prisma.bakery.findUnique({ 
     where: { id },
     include: { owner: true }
   });
   ```

2. **Update Status:**
   ```javascript
   await prisma.bakery.update({
     where: { id },
     data: { 
       status: 'approved',
       updatedBy: req.user.id
     }
   });
   ```

3. **Verify User:**
   ```javascript
   // Check if all bakeries are approved
   const pendingCount = await prisma.bakery.count({
     where: {
       ownerId: vendor.ownerId,
       status: 'pending_approval',
       deletedAt: null
     }
   });
   
   if (pendingCount === 0) {
     // All bakeries approved → verify user
     await prisma.user.update({
       where: { id: vendor.ownerId },
       data: { 
         isVerified: true,
         updatedBy: req.user.id
       }
     });
   }
   ```

**Result:**
- ✅ Bakery `status: 'approved'`
- ✅ User `isVerified: true` (if all bakeries approved)
- ✅ User can now login

---

## ❌ Step 6: Backend - Rejection Process

### Location: `khubzati_api_project 2/src/routes/admin.js`

**Endpoint:** `PUT /admin/vendors/:id/reject`

**Process:**

1. **Update Status:**
   ```javascript
   await prisma.bakery.update({
     where: { id },
     data: { 
       status: 'rejected',
       updatedBy: req.user.id
     }
   });
   ```

2. **Unverify User (if no approved bakeries):**
   ```javascript
   const approvedCount = await prisma.bakery.count({
     where: {
       ownerId: vendor.ownerId,
       status: 'approved',
       deletedAt: null
     }
   });
   
   if (approvedCount === 0) {
     // No approved bakeries → unverify user
     await prisma.user.update({
       where: { id: vendor.ownerId },
       data: { 
         isVerified: false,
         updatedBy: req.user.id
       }
     });
   }
   ```

**Result:**
- ❌ Bakery `status: 'rejected'`
- ❌ User `isVerified: false` (if no approved bakeries)
- ❌ User **cannot login**

**⚠️ Issue:** Documents (commercial registry) are **NOT returned** to user. They remain in the system but are not accessible.

---

## 🚫 Step 7: Login Blocking

### Location: `khubzati_api_project 2/src/routes/auth.js`

**Function:** `ensureVendorEligibility(user)`

**Called During:**
- `POST /auth/login` (after OTP verification)
- `POST /auth/resend-otp` (before sending OTP)

**Process:**

```javascript
const ensureVendorEligibility = async (user) => {
  if (user.role !== 'bakery_owner' && user.role !== 'restaurant_owner') {
    return; // Customers can login freely
  }

  // Check for approved bakery
  const approvedVendor = await prisma.bakery.findFirst({ 
    where: {
      ownerId: user.id,
      status: 'approved',
      deletedAt: null
    }
  });
  
  if (approvedVendor) return; // ✅ Has approved bakery → allow login

  // Check for pending bakery
  const pendingVendor = await prisma.bakery.findFirst({ 
    where: {
      ownerId: user.id,
      status: 'pending_approval',
      deletedAt: null
    }
  });
  
  if (pendingVendor) {
    // ❌ Pending approval → block login
    throw new Error('Your bakery registration is pending admin approval. Please wait for approval before logging in.');
    // Error includes: { pendingApproval: true }
  }

  // ❌ No bakery registered → block login
  throw new Error('You must register a bakery and get admin approval before logging in.');
  // Error includes: { noVendor: true }
};
```

**Error Response:**
```json
{
  "status": "fail",
  "message": "Your bakery registration is pending admin approval...",
  "pendingApproval": true,
  "noVendor": false
}
```

---

## 📱 Step 8: Mobile App - Login Handling

### Location: `lib/features/auth/presentation/screens/login_screen.dart`

**Current Behavior:**

1. **User Enters Phone Number:**
   - Firebase phone verification
   - OTP sent via SMS

2. **OTP Verification:**
   - User enters OTP
   - Firebase verifies
   - Backend login called

3. **Backend Login:**
   ```dart
   context.read<AuthBloc>().add(LoginRequested(
     emailOrPhone: phoneForBackend
   ));
   ```

4. **Error Handling:**
   ```dart
   // In auth_service.dart
   if (error.statusCode == 403) {
     final pendingApproval = errorData['pendingApproval'] == true;
     final noVendor = errorData['noVendor'] == true;
     
     // Error is thrown with these flags
   }
   ```

5. **UI Response:**
   ```dart
   // Currently just shows error message
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(state.message),
       backgroundColor: Colors.red,
     ),
   );
   ```

**⚠️ Issue:** No special UI for pending approval status. User just sees error message.

---

## 🔍 Issues Found

### ❌ Issue 1: Commercial Registry Not Uploaded/Stored (CRITICAL)

**Problem:**
- Mobile app **selects** commercial registry file but **NEVER uploads it**
- `FileUploadRequested` event exists but handler is **NOT implemented in AuthBloc**
- File remains on device, never sent to server
- Backend has no file upload endpoint for documents
- Bakery schema has no `commercialRegistryUrl` field
- **Document is completely lost** - admin never sees it

**Current Code:**
```dart
// File is selected but never uploaded
LabeledFileUpload(
  onFileSelected: (path, name) {
    _selectedCommercialRegistryFileName = name; // Only stores filename
    // File is NOT uploaded to server!
  }
);
```

**Impact:**
- ❌ Admin cannot view commercial registry (file never uploaded)
- ❌ Documents cannot be returned on rejection (file doesn't exist on server)
- ❌ Important verification document is completely lost
- ❌ User thinks document is uploaded but it's not

**Solution Needed:**
1. **Implement file upload handler in AuthBloc:**
   ```dart
   Future<void> _onFileUploadRequested(
     FileUploadRequested event,
     Emitter<AuthState> emit
   ) async {
     // Upload file to server
     // Get file URL
     // Store URL in state
   }
   ```

2. **Create file upload endpoint in backend:**
   ```javascript
   POST /upload/document
   // Accepts multipart/form-data
   // Returns file URL
   ```

3. **Add `commercialRegistryUrl` field to Bakery schema:**
   ```prisma
   model Bakery {
     commercialRegistryUrl String? @map("commercial_registry_url")
   }
   ```

4. **Update bakery registration to include document URL**

5. **Display in admin interface**

---

### ❌ Issue 2: No Document Return on Rejection

**Problem:**
- When admin rejects application, documents are not returned
- User has no way to retrieve uploaded documents
- Documents remain in system but inaccessible

**Solution Needed:**
1. Store document URLs in database
2. Provide API endpoint to retrieve documents
3. Show documents in mobile app for rejected applications
4. Allow user to download/access their documents

---

### ⚠️ Issue 3: Poor UX for Pending Approval

**Problem:**
- User sees generic error message
- No clear indication of approval status
- No way to check status in app
- User doesn't know if application is being reviewed

**Solution Needed:**
1. Add approval status screen in mobile app
2. Show pending/rejected status clearly
3. Display rejection reason if rejected
4. Allow user to check status anytime

---

### ⚠️ Issue 4: Login Blocked Before OTP

**Problem:**
- `ensureVendorEligibility` is called in `resend-otp` endpoint
- User cannot even request OTP if pending/rejected
- Should allow OTP request, block only after verification

**Current Code:**
```javascript
// In /auth/resend-otp
if (purpose === 'login') {
  await ensureVendorEligibility(user); // ❌ Blocks before OTP
}
```

**Solution:** Remove vendor check from resend-otp, only check after OTP verification.

---

## ✅ What's Working

1. ✅ User registration works
2. ✅ Bakery registration creates pending approval
3. ✅ Admin can view and approve/reject vendors
4. ✅ Login is properly blocked for pending/rejected
5. ✅ Approval updates user verification status
6. ✅ Rejection unverifies user correctly

---

## 📋 Recommended Fixes

### Priority 1: Store Commercial Registry

1. **Update Database Schema:**
   ```prisma
   model Bakery {
     // ... existing fields
     commercialRegistryUrl String? @map("commercial_registry_url")
   }
   ```

2. **Update Backend API:**
   ```javascript
   // In POST /bakeries
   const bakery = await prisma.bakery.create({
     data: {
       // ... existing fields
       commercialRegistryUrl: req.body.commercialRegistryUrl,
     }
   });
   ```

3. **Update Mobile App:**
   - Upload commercial registry file
   - Get file URL from upload endpoint
   - Include in bakery registration

4. **Update Admin Interface:**
   - Display commercial registry document
   - Allow download/view

---

### Priority 2: Improve Mobile UX

1. **Add Approval Status Screen:**
   - Show pending/approved/rejected status
   - Display rejection reason if rejected
   - Show documents that were uploaded

2. **Better Error Messages:**
   - Custom dialog for pending approval
   - Clear instructions on what to do
   - Link to check status

3. **Status Check Endpoint:**
   - `GET /user/bakery-status`
   - Returns current approval status
   - Shows rejection reason if rejected

---

### Priority 3: Document Return on Rejection

1. **Store All Documents:**
   - Commercial registry URL
   - Logo URL
   - Cover image URL

2. **API Endpoint:**
   ```javascript
   GET /user/documents
   // Returns all uploaded documents for user's bakery
   ```

3. **Mobile App:**
   - Show documents screen
   - Allow download of documents
   - Display rejection reason with documents

---

## 🧪 Testing Checklist

### Signup Flow:
- [ ] User can fill signup form
- [ ] Documents can be uploaded (logo, commercial registry)
- [ ] Phone verification works
- [ ] OTP verification works
- [ ] User is registered in backend
- [ ] Bakery is created with `pending_approval` status
- [ ] Documents are stored (when fixed)

### Admin Flow:
- [ ] Admin can see pending vendors
- [ ] Admin can view vendor details
- [ ] Admin can see uploaded documents (when fixed)
- [ ] Admin can approve vendor
- [ ] Admin can reject vendor with reason
- [ ] Approval updates bakery status to `approved`
- [ ] Approval sets `user.isVerified: true`
- [ ] Rejection updates bakery status to `rejected`
- [ ] Rejection sets `user.isVerified: false` (if no approved bakeries)

### Login Flow:
- [ ] Approved bakery owner can login ✅
- [ ] Pending bakery owner is blocked ❌
- [ ] Rejected bakery owner is blocked ❌
- [ ] Error message shows pending approval status
- [ ] Error message shows rejection reason (when implemented)

### Document Flow:
- [ ] Documents are uploaded during signup
- [ ] Documents are stored in database (when fixed)
- [ ] Admin can view documents (when fixed)
- [ ] User can access documents after rejection (when implemented)

---

## 📝 Code Locations Summary

### Mobile App:
- **Signup:** `lib/features/auth/presentation/screens/signup_screen.dart`
- **Login:** `lib/features/auth/presentation/screens/login_screen.dart`
- **OTP:** `lib/features/auth/presentation/screens/otp_verification_screen.dart`
- **Auth Logic:** `lib/features/auth/application/blocs/auth_bloc.dart`
- **File Upload:** `lib/features/auth/presentation/widgets/personal_info_step.dart`

### Backend API:
- **User Registration:** `khubzati_api_project 2/src/routes/auth.js` (POST /auth/register)
- **Bakery Registration:** `khubzati_api_project 2/src/routes/bakeries.js` (POST /bakeries)
- **Login Check:** `khubzati_api_project 2/src/routes/auth.js` (ensureVendorEligibility)
- **Admin Approve:** `khubzati_api_project 2/src/routes/admin.js` (PUT /admin/vendors/:id/approve)
- **Admin Reject:** `khubzati_api_project 2/src/routes/admin.js` (PUT /admin/vendors/:id/reject)

### Admin Interface:
- **Vendor List:** `admin/src/app/vendors/page.tsx`
- **Vendor Details:** `admin/src/app/vendors/[id]/page.tsx`
- **Approve/Reject:** `admin/src/shared/store/vendorStore.ts`

---

## 🎯 Next Steps

1. **Fix Commercial Registry Storage** (Priority 1)
2. **Add Approval Status Screen** (Priority 2)
3. **Improve Error Messages** (Priority 2)
4. **Implement Document Return** (Priority 3)
5. **Add Status Check Endpoint** (Priority 3)

---

**Last Updated:** December 2024

