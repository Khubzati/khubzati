# Khubzati Admin Interface Proposal

## Overview
Based on the Khubzati business model (a platform connecting bakeries and restaurants with customers), this document outlines the comprehensive admin interface needed to manage and oversee the entire platform operations.

## Business Context
- **Platform Type**: Marketplace connecting vendors (bakeries & restaurants) with customers
- **User Roles**: Customers, Bakery Owners, Restaurant Owners, Drivers, Admin
- **Core Flow**: Vendors need approval → Customers order → Orders processed → Delivery handled
- **Key Features**: Order management, product catalogs, reviews, analytics, notifications

---

## 1. Admin Dashboard (Main Screen)

### Overview Cards
- **Total Users**: Break down by role (Customers, Bakery Owners, Restaurant Owners, Drivers)
- **Total Vendors**: Active bakeries + restaurants (with pending approval count)
- **Today's Orders**: Total orders today with status breakdown
- **Revenue**: Total revenue (today, this week, this month)
- **Pending Approvals**: Count of bakeries/restaurants awaiting approval
- **Active Issues**: Count of flagged reviews, disputes, support tickets

### Quick Stats
- **Platform Growth**: User registration trends (7 days, 30 days, 90 days)
- **Order Volume**: Orders per day/week/month
- **Vendor Status**: Active vs Inactive vendors
- **Customer Retention**: New vs returning customers

### Recent Activity Feed
- New vendor registrations (pending approval)
- High-value orders
- Reported reviews/products
- User account issues
- System alerts

---

## 2. Vendor Management (Bakery & Restaurant Approval)

### Pending Approvals Section
- **List View**: All bakeries/restaurants with `pending_approval` status
- **Filters**: By type (bakery/restaurant), registration date, city
- **Search**: By name, owner email, phone number
- **Details View** for each vendor shows:
  - Owner information (name, email, phone)
  - Business details (name, description, address, contact info)
  - Commercial registry documents
  - Logo and cover images
  - Operating hours
  - Registration date

### Actions Available
- **Approve**: Changes status to `approved`, sends notification to owner
- **Reject**: Changes status to `rejected`, with reason field (required)
- **Request More Info**: Send notification to owner with clarification requests
- **View on Map**: See vendor location

### Active Vendors Management
- **List All Approved Vendors**: With status toggle (active/inactive)
- **Vendor Profile**: Edit any vendor information
- **Vendor Performance**: Order count, revenue, average rating
- **Suspend Vendor**: Temporarily suspend (hide from customers)
- **View Products**: See all products from this vendor
- **View Reviews**: Monitor customer reviews

### Vendor Analytics (per vendor)
- Total orders
- Total revenue
- Average rating
- Product count
- Response time to orders

---

## 3. User Management

### User List
- **Filters**: By role (customer, bakery_owner, restaurant_owner, driver, admin)
- **Search**: By name, email, phone number, user ID
- **Status Filters**: Verified, Unverified, Active, Suspended, Deleted
- **Columns**: Name, Email, Phone, Role, Status, Registration Date, Last Login

### User Details
- **Profile Information**: Full profile view
- **Account Status**: Active, Suspended, Deleted
- **Verification Status**: Email/Phone verified
- **Order History**: All orders placed (for customers)
- **Vendor Associations**: Owned bakeries/restaurants
- **Reviews Posted**: All reviews by this user
- **Activity Log**: Login history, significant actions

### Actions
- **Suspend Account**: Block user from accessing platform
- **Delete Account**: Soft delete with data retention option
- **Verify Account**: Manually verify email/phone
- **Reset Password**: Admin-initiated password reset
- **Change Role**: Upgrade/downgrade user role (e.g., customer → bakery_owner)
- **Send Notification**: Push notification to user
- **View Activity**: Complete activity history

---

## 4. Order Management & Oversight

### Order Dashboard
- **All Orders**: Complete order list across all vendors
- **Filters**: 
  - By status (pending, confirmed, preparing, ready_for_pickup, out_for_delivery, delivered, completed, cancelled)
  - By vendor (bakery/restaurant)
  - By customer
  - By date range
  - By payment status
- **Search**: By order number, customer name, vendor name

### Order Details View
- **Order Information**: Order number, date, time, status
- **Customer Details**: Name, contact, delivery address
- **Vendor Details**: Bakery/Restaurant name, contact
- **Order Items**: All products with quantities and prices
- **Payment Information**: Method, status, transaction details
- **Delivery Information**: Type (pickup/delivery), address, estimated time
- **Timeline**: Status change history
- **Special Notes**: Customer instructions, vendor notes

### Admin Actions on Orders
- **Cancel Order**: Force cancel with refund option
- **Update Status**: Manually change order status
- **Add Notes**: Internal admin notes (not visible to customer/vendor)
- **Refund Processing**: Initiate refunds
- **Assign Driver**: Manually assign delivery driver
- **Contact Customer/Vendor**: Quick contact buttons

### Order Analytics
- **Volume Trends**: Orders over time
- **Status Distribution**: Pie chart of order statuses
- **Top Vendors**: By order volume
- **Cancellation Rate**: Track cancellation patterns
- **Average Order Value**: Track AOV trends
- **Popular Products**: Best-selling items across platform

---

## 5. Content Moderation

### Product Moderation
- **Flagged Products**: Products reported by users or flagged by system
- **New Products**: Recently added products awaiting review (optional)
- **Product List**: All products with ability to:
  - Edit product details
  - Hide/Show products
  - Delete products (soft delete)
  - View product reviews
- **Search/Filter**: By vendor, category, availability

### Review Moderation
- **Flagged Reviews**: Reviews reported by users
- **Review List**: All reviews with:
  - Review content, rating, reviewer info
  - Reported count
  - Reason for flagging (if flagged)
- **Actions**:
  - Approve: Keep review visible
  - Hide: Hide from public view (keep in system)
  - Delete: Remove review completely
  - Mark as Spam: Auto-hide similar patterns

### Category Management
- **Category List**: All categories (bakery, restaurant, common)
- **Create/Edit Categories**:
  - Name, description, image
  - Type (bakery, restaurant, common)
  - Parent category (for subcategories)
  - Display order
- **Category Hierarchy**: Tree view for nested categories
- **Category Analytics**: Products per category, popularity

---

## 6. Driver Management

### Driver List
- **All Drivers**: Registered drivers on platform
- **Status**: Available, On Delivery, Offline, Suspended
- **Performance Metrics**: 
  - Total deliveries
  - Average rating
  - Completion rate
  - Response time
- **Verification Status**: Documents verified

### Driver Details
- **Profile**: Personal information, documents
- **Location**: Current location (if available)
- **Active Deliveries**: Current delivery assignments
- **Delivery History**: Past deliveries with ratings
- **Earnings**: Total earnings, payment history

### Actions
- **Approve Driver**: Verify and activate driver account
- **Suspend Driver**: Temporarily suspend from platform
- **View Location**: Real-time location tracking (if enabled)
- **Assign Delivery**: Manually assign order to driver
- **Performance Review**: View detailed performance metrics

---

## 7. Analytics & Reports

### Platform Analytics Dashboard
- **Revenue Analytics**:
  - Total revenue (daily, weekly, monthly, yearly)
  - Revenue by vendor type (bakery vs restaurant)
  - Revenue trends (growth/decline)
  - Payment method distribution

- **Order Analytics**:
  - Total orders over time
  - Order status distribution
  - Average order value trends
  - Peak ordering times
  - Order cancellation analysis

- **User Analytics**:
  - User growth (registrations over time)
  - Active users (daily, weekly, monthly)
  - User retention rate
  - User distribution by role
  - Geographic distribution

- **Vendor Analytics**:
  - Total vendors (active, pending, suspended)
  - Vendor growth trends
  - Top performing vendors (by revenue, orders, rating)
  - Vendor retention
  - Vendor performance comparison

- **Product Analytics**:
  - Total products
  - Top selling products
  - Product categories popularity
  - Low stock alerts

- **Review Analytics**:
  - Average platform rating
  - Review count trends
  - Review distribution (rating breakdown)
  - Most reviewed vendors/products

### Exportable Reports
- **Revenue Reports**: Export revenue data (CSV, PDF)
- **Order Reports**: Detailed order reports
- **User Reports**: User activity reports
- **Vendor Reports**: Vendor performance reports
- **Custom Date Range**: All reports with date filtering

---

## 8. System Settings & Configuration

### Platform Settings
- **General Settings**:
  - Platform name, logo
  - Default currency
  - Tax rates
  - Delivery fee settings
  - Minimum order amount

- **Commission Settings**:
  - Platform commission percentage (per order)
  - Different rates for bakeries vs restaurants (if applicable)

- **Operating Hours**:
  - Default operating hours
  - Holiday settings

### Notification Settings
- **Email Templates**: Edit email notification templates
- **Push Notification Settings**: Configure push notification settings
- **SMS Settings**: SMS notification configuration (if applicable)

### Payment Settings
- **Payment Gateways**: Configure payment methods
- **Wallet Settings**: Platform wallet configuration
- **Refund Policies**: Set refund rules and policies

### Content Settings
- **Featured Vendors**: Manually feature vendors on homepage
- **Featured Products**: Feature specific products
- **Promotional Banners**: Manage app banners/promotions

### Security Settings
- **Password Policies**: Minimum requirements
- **Session Management**: Session timeout settings
- **IP Whitelisting**: Restrict admin access by IP (optional)

---

## 9. Support & Disputes

### Customer Support Tickets
- **Ticket List**: All support requests from users
- **Categories**: Order issues, payment problems, account issues, technical support
- **Status**: Open, In Progress, Resolved, Closed
- **Priority**: Low, Medium, High, Urgent
- **Assign to**: Support team member
- **Response Tracking**: Track response times

### Dispute Resolution
- **Order Disputes**: Disputes related to orders
  - Refund requests
  - Quality complaints
  - Delivery issues
  - Payment disputes
- **Vendor Disputes**: Issues between vendors and customers
- **Actions**: 
  - Resolve dispute (with resolution notes)
  - Escalate to higher level
  - Issue refund
  - Compensate customer

### Communication Center
- **Send Broadcast Messages**: Send notifications to all users or specific segments
- **Announcements**: Platform-wide announcements
- **Maintenance Notices**: Schedule and send maintenance notifications

---

## 10. Audit Log & Security

### Activity Log
- **Admin Actions**: All actions performed by admins
  - Who: Admin user
  - What: Action performed
  - When: Timestamp
  - Details: Relevant data
- **System Events**: Important system events logged
- **Filter/Search**: By admin, action type, date range

### Security Monitoring
- **Failed Login Attempts**: Track suspicious login attempts
- **Account Compromises**: Flag potentially compromised accounts
- **API Usage**: Monitor API calls and anomalies
- **Data Export Logs**: Track when sensitive data is exported

### User Privacy
- **Data Requests**: Handle user data access/deletion requests (GDPR compliance)
- **Account Deletion**: Process account deletion requests
- **Data Export**: Export user data on request

---

## 11. Technical Features

### Search & Filters
- **Global Search**: Search across users, vendors, orders, products
- **Advanced Filters**: Complex filtering on all list views
- **Saved Filters**: Save frequently used filter combinations

### Bulk Actions
- **Bulk Approve/Reject**: Approve/reject multiple vendors at once
- **Bulk User Actions**: Suspend, verify, delete multiple users
- **Bulk Status Updates**: Update multiple orders/products at once

### Export & Import
- **Data Export**: Export any list to CSV/Excel
- **Report Generation**: Generate PDF reports
- **Data Import**: Import bulk data (categories, products, etc.)

### Notifications
- **In-App Notifications**: Real-time notifications for admin actions
- **Email Notifications**: Email alerts for important events
- **Dashboard Alerts**: Visual alerts on dashboard

---

## 12. Mobile App Admin Interface Structure

### Navigation Structure
```
Admin Dashboard
├── Dashboard (Home)
├── Vendors
│   ├── Pending Approvals
│   ├── Bakeries
│   ├── Restaurants
│   └── Vendor Analytics
├── Users
│   ├── All Users
│   ├── Customers
│   ├── Vendors
│   └── Drivers
├── Orders
│   ├── All Orders
│   ├── Active Orders
│   ├── Completed Orders
│   └── Order Analytics
├── Content
│   ├── Products
│   ├── Reviews
│   └── Categories
├── Drivers
│   ├── Driver List
│   ├── Active Deliveries
│   └── Performance
├── Analytics
│   ├── Platform Overview
│   ├── Revenue Reports
│   ├── User Reports
│   └── Vendor Reports
├── Support
│   ├── Tickets
│   ├── Disputes
│   └── Announcements
├── Settings
│   ├── Platform Settings
│   ├── Payment Settings
│   └── Security Settings
└── Audit Log
```

---

## 13. Priority Features (MVP)

### Phase 1 (Critical - Launch)
1. **Vendor Approval System**
   - View pending bakeries/restaurants
   - Approve/reject with reason
   - Basic vendor management

2. **User Management**
   - View all users
   - Suspend/activate accounts
   - Basic user details

3. **Order Oversight**
   - View all orders
   - Basic order details
   - Manual order cancellation

4. **Basic Dashboard**
   - Key metrics
   - Recent activity

### Phase 2 (Important - Post Launch)
1. **Content Moderation**
   - Review moderation
   - Product management
   
2. **Enhanced Analytics**
   - Revenue reports
   - Order analytics
   - User growth metrics

3. **Support System**
   - Basic ticket system
   - Dispute resolution

### Phase 3 (Enhancement)
1. **Advanced Analytics**
   - Custom reports
   - Export functionality

2. **Driver Management**
   - Full driver oversight

3. **Advanced Settings**
   - Platform configuration
   - System settings

---

## 14. UI/UX Considerations

### Design Principles
- **Clean & Organized**: Easy to navigate, clear hierarchy
- **Data-Dense but Readable**: Show important info without clutter
- **Action-Oriented**: Quick access to common actions
- **Mobile-First**: Responsive design for tablet/phone use
- **Search & Filter**: Powerful search and filtering on all lists

### Key Screens
1. **Dashboard**: Overview with key metrics and quick actions
2. **List Views**: Consistent table/list design across modules
3. **Detail Views**: Comprehensive information with action buttons
4. **Forms**: Clean forms for editing/creating entities
5. **Analytics**: Visual charts and graphs for data insights

### Color Coding
- **Pending**: Orange/Yellow
- **Approved/Active**: Green
- **Rejected/Suspended**: Red
- **In Progress**: Blue
- **Completed**: Gray

---

## 15. API Endpoints Needed

### Admin Auth
- `POST /api/admin/login`: Admin login
- `POST /api/admin/logout`: Admin logout

### Vendor Management
- `GET /api/admin/vendors/pending`: Get pending vendors
- `PUT /api/admin/vendors/:id/approve`: Approve vendor
- `PUT /api/admin/vendors/:id/reject`: Reject vendor
- `GET /api/admin/vendors`: Get all vendors
- `PUT /api/admin/vendors/:id/status`: Update vendor status

### User Management
- `GET /api/admin/users`: Get all users
- `GET /api/admin/users/:id`: Get user details
- `PUT /api/admin/users/:id/status`: Update user status
- `PUT /api/admin/users/:id/role`: Change user role

### Order Management
- `GET /api/admin/orders`: Get all orders
- `GET /api/admin/orders/:id`: Get order details
- `PUT /api/admin/orders/:id/status`: Update order status
- `POST /api/admin/orders/:id/cancel`: Cancel order

### Analytics
- `GET /api/admin/analytics/overview`: Get dashboard overview
- `GET /api/admin/analytics/revenue`: Get revenue analytics
- `GET /api/admin/analytics/orders`: Get order analytics
- `GET /api/admin/analytics/users`: Get user analytics

### Content Moderation
- `GET /api/admin/products`: Get all products
- `PUT /api/admin/products/:id/status`: Update product status
- `GET /api/admin/reviews/flagged`: Get flagged reviews
- `PUT /api/admin/reviews/:id/status`: Update review status

### Categories
- `GET /api/admin/categories`: Get all categories
- `POST /api/admin/categories`: Create category
- `PUT /api/admin/categories/:id`: Update category
- `DELETE /api/admin/categories/:id`: Delete category

---

## Conclusion

This admin interface provides comprehensive oversight and management capabilities for the Khubzati platform, covering all aspects from vendor onboarding to order management, content moderation, and analytics. The modular structure allows for phased implementation, starting with critical features for launch and expanding with additional capabilities over time.

The interface should prioritize ease of use, powerful filtering/search capabilities, and actionable insights to help admins efficiently manage the platform and support vendors and customers effectively.

