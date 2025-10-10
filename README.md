# LoanApplication

A simple end‑to‑end Loan Management web app built with ASP.NET Web Forms (C#) targeting .NET Framework 4.7.2 and MySQL. It lets users register and log in, browse loan types, calculate EMI, submit loan applications with document upload, and view/delete their applications. Admins can log in, view and filter applications, approve/reject/move to trash, restore deleted applications, and manage loan types (CRUD).

Note: This project uses classic ASP.NET Web Forms and IIS Express (via Visual Studio). It does not require .NET Core.

## Features

- User
  - Register with profile details (name, email, phone, address, occupation, monthly income)
  - Login with email/password (session-based)
  - Explore loan types (from DB) and view details in modals
  - EMI calculation from selected loan type and amount
  - Apply for a loan with file upload (PDF/Image)
  - See “Your Applications” and delete an application
- Admin
  - Admin login (username/password)
  - Dashboard: search/filter applications; approve/reject/delete (to Trash)
  - Trash: restore deleted applications back to main table
  - Settings: manage loan types (create/update/delete)

## Tech stack

- ASP.NET Web Forms (C#), .NET Framework 4.7.2
- IIS Express (development), Visual Studio 2019/2022
- MySQL (via `MySql.Data` NuGet package)
- Other NuGet packages: Microsoft.CodeDom.Providers.DotNetCompilerPlatform, BouncyCastle, K4os LZ4, System.* libs

## Prerequisites

- Windows with Visual Studio 2019 or 2022 (ASP.NET and web development workload)
- .NET Framework 4.7.2 targeting pack (installed with VS)
- MySQL Server (local or hosted) and a database you can connect to
- NuGet package restore (Visual Studio handles this automatically)

## Getting started

1) Clone the repository

```bash
# Using HTTPS
git clone https://github.com/kiranadep/LoanApplication.git
cd LoanApplication
```

2) Open the solution

- Open `LoanApplication.sln` in Visual Studio
- Let Visual Studio restore NuGet packages

3) Configure the database connection

- Edit `LoanApplication/Web.config` and set the `LoanAppDB` connection string to your MySQL instance. Do NOT commit real secrets in public repos.

Example (replace placeholders):

```xml
<connectionStrings>
  <add name="LoanAppDB"
       connectionString="server={{DB_HOST}};port={{DB_PORT}};database={{DB_NAME}};uid={{DB_USER}};pwd={{DB_PASSWORD}};"
       providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

Recommended: use `Web.Debug.config`/`Web.Release.config` transforms to inject secrets on your machine or your CI/CD, rather than committing plain-text credentials.

4) Create required tables (MySQL)

The pages reference these tables/columns. You can start with this baseline schema and adjust as needed.

```sql
-- Admin users
CREATE TABLE IF NOT EXISTS Admin (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  Username VARCHAR(100) NOT NULL,
  Password VARCHAR(255) NOT NULL
);

-- Application users
CREATE TABLE IF NOT EXISTS Users (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  FullName VARCHAR(200) NOT NULL,
  Email VARCHAR(200) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  Address VARCHAR(500) NOT NULL,
  Occupation VARCHAR(100) NOT NULL,
  MonthlyIncome DECIMAL(18,2) NOT NULL
);

-- Loan types catalog
CREATE TABLE IF NOT EXISTS LoanTypes (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  LoanName VARCHAR(200) NOT NULL,
  LoanIcon VARCHAR(50) NULL,
  LoanSummary VARCHAR(500) NULL,
  LoanDetails TEXT NULL,
  Eligibility TEXT NULL,
  InterestRate DECIMAL(5,2) NOT NULL,
  MaxAmount DECIMAL(18,2) NULL,
  Tenure VARCHAR(100) NULL
);

-- Loan applications
CREATE TABLE IF NOT EXISTS LoanApplications (
  ApplicationID INT AUTO_INCREMENT PRIMARY KEY,
  FullName VARCHAR(200) NOT NULL,
  Email VARCHAR(200) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  Address VARCHAR(500) NOT NULL,
  LoanType VARCHAR(200) NOT NULL,
  LoanAmount DECIMAL(18,2) NOT NULL,
  EmploymentType VARCHAR(100) NOT NULL,
  MonthlyIncome DECIMAL(18,2) NOT NULL,
  TotalAmount DECIMAL(18,2) NULL,
  Deadline VARCHAR(50) NULL,
  DurationMonths INT NULL,
  MonthlyPayable DECIMAL(18,2) NULL,
  Status VARCHAR(50) NOT NULL DEFAULT 'Pending',
  AppliedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Document LONGBLOB NULL
);

-- Deleted applications (trash bin)
CREATE TABLE IF NOT EXISTS DeletedApplications (
  ApplicationID INT PRIMARY KEY,
  FullName VARCHAR(200) NOT NULL,
  Email VARCHAR(200) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  Address VARCHAR(500) NOT NULL,
  LoanType VARCHAR(200) NOT NULL,
  LoanAmount DECIMAL(18,2) NOT NULL,
  EmploymentType VARCHAR(100) NOT NULL,
  MonthlyIncome DECIMAL(18,2) NOT NULL,
  Status VARCHAR(50) NOT NULL,
  AppliedAt DATETIME NOT NULL
);
```

Important: Some pages reference `ApplicationID` while another uses `ApplicationId`. On MySQL servers configured with case-sensitive identifiers (e.g., on Linux), prefer a consistent name (e.g., `ApplicationID`) and update queries accordingly.

5) Run the app

- In Visual Studio, set `LoanApplication` as the startup project (right-click → Set as Startup Project)
- Press F5 (Debug) or Ctrl+F5 (Run without debugging)
- The app runs on IIS Express; the configured URL is typically `https://localhost:44399/`

Entry points:
- User browsing: `/Loans/userview.aspx`
- Loan apply form: `/Loans/Loan.aspx`
- User login: `/User/login.aspx`
- User register: `/User/Register.aspx`
- Admin login: `/Admin/Admin.aspx`
- Admin dashboard: `/Admin/AdminDashboard.aspx`
- Admin settings (loan types): `/Admin/Settings.aspx`
- Admin trash: `/Admin/Trash.aspx`

## Project structure

```text
LoanApplication.sln                      # Visual Studio solution
LoanApplication/                         # Web Forms project (ASP.NET, .NET Framework 4.7.2)
  Global.asax                            # Application lifecycle hook
  Global.asax.cs                         # Application_Start etc.
  Web.config                             # App configuration (connectionStrings, compilation)
  Web.Debug.config                       # Debug transform (use for local secrets)
  Web.Release.config                     # Release transform
  packages.config                        # NuGet package references
  Properties/AssemblyInfo.cs             # Assembly metadata

  Contents/css/AdminPanel.css            # Styles for admin UI

  Admin/                                 # Admin area
    Admin.aspx                           # Admin login (validates against Admin table)
    Admin.aspx.cs                        # Code-behind
    AdminDashboard.aspx                  # Approve/reject/delete loan applications; search/filter
    AdminDashboard.aspx.cs               # Handles session logout
    Settings.aspx                        # CRUD for LoanTypes (inline server code)
    Trash.aspx                           # View deleted apps and restore
    Restore.aspx                         # Endpoint that restores a deleted app
    Users.aspx                           # Placeholder for viewing users

  Loans/                                 # Loan user flows
    userview.aspx                        # Landing page; lists loan types; session-aware header
    Loan.aspx                            # EMI calculation + submit application with document upload
    yourapp.aspx                         # Shows current user's applications; allows delete

  User/                                  # Authentication (end-user)
    login.aspx                           # User login (session-based)
    Register.aspx                        # User registration form
```

## How it works (high level)

- Session-based auth for users (UserID/UserName/UserEmail session keys) and admin (AdminUser session key)
- Direct MySQL access with parameterized queries using `MySql.Data`
- EMI calculation performed server-side in `Loans/Loan.aspx` when the user clicks Calculate
- File uploads stored as BLOB (`Document` column in `LoanApplications`)
- Admin actions mutate `LoanApplications` and `DeletedApplications` tables

## Security notes (important)

- Do NOT commit real database credentials. Use config transforms or local secrets. Redact connection strings before pushing.
- Passwords for users/admins are currently stored/compared in plain text. For any real use, hash with a strong algorithm (e.g., BCrypt/Argon2) and add salt and proper policies.
- Validate and sanitize all inputs; consider server-side validation classes and centralized error handling.
- Limit file upload types and size; scan uploads if you plan to persist them.

## Troubleshooting

- Connection string 'LoanAppDB' not found
  - Ensure `Web.config` contains a valid `<connectionStrings>` entry and that Visual Studio is running the correct configuration.
- MySQL connection/auth errors
  - Verify host/port credentials, firewall rules, and that the account has rights to the target database.
- Table/column not found
  - Create tables with the names used by the code; align `ApplicationID` casing consistently across queries.
- Port already in use
  - Change IIS Express port in project properties or close the process using that port.

## Contributing

PRs are welcome for:
- Moving secrets out of Web.config (user secrets or transforms)
- Password hashing and auth improvements
- Adding proper DAL/repository and models instead of inline SQL
- Unit/integration tests
- UI/UX refinements

## License

Add a LICENSE file if you intend to open-source under a specific license.
