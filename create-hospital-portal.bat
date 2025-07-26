@echo off
echo Creating Hospital Admin Portal Project Structure...
echo ================================================

REM Create main directories
mkdir backend\api-gateway\src\main\java\com\hospital\gateway\config 2>nul
mkdir backend\api-gateway\src\main\java\com\hospital\gateway\filter 2>nul
mkdir backend\api-gateway\src\main\java\com\hospital\gateway\controller 2>nul
mkdir backend\api-gateway\src\main\resources 2>nul

mkdir backend\user-service\src\main\java\com\hospital\user\entity 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\repository 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\service 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\controller 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\dto 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\config 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\security 2>nul
mkdir backend\user-service\src\main\java\com\hospital\user\util 2>nul
mkdir backend\user-service\src\main\resources 2>nul

mkdir backend\patient-service\src\main\java\com\hospital\patient\entity 2>nul
mkdir backend\patient-service\src\main\java\com\hospital\patient\repository 2>nul
mkdir backend\patient-service\src\main\java\com\hospital\patient\service 2>nul
mkdir backend\patient-service\src\main\java\com\hospital\patient\controller 2>nul
mkdir backend\patient-service\src\main\java\com\hospital\patient\dto 2>nul
mkdir backend\patient-service\src\main\resources 2>nul

mkdir backend\appointment-service\src\main\java\com\hospital\appointment\entity 2>nul
mkdir backend\appointment-service\src\main\java\com\hospital\appointment\repository 2>nul
mkdir backend\appointment-service\src\main\java\com\hospital\appointment\service 2>nul
mkdir backend\appointment-service\src\main\java\com\hospital\appointment\controller 2>nul
mkdir backend\appointment-service\src\main\java\com\hospital\appointment\dto 2>nul
mkdir backend\appointment-service\src\main\resources 2>nul

mkdir backend\department-service\src\main\java\com\hospital\department\entity 2>nul
mkdir backend\department-service\src\main\java\com\hospital\department\repository 2>nul
mkdir backend\department-service\src\main\java\com\hospital\department\service 2>nul
mkdir backend\department-service\src\main\java\com\hospital\department\controller 2>nul
mkdir backend\department-service\src\main\java\com\hospital\department\dto 2>nul
mkdir backend\department-service\src\main\resources 2>nul

mkdir backend\medical-service\src\main\java\com\hospital\medical\entity 2>nul
mkdir backend\medical-service\src\main\java\com\hospital\medical\repository 2>nul
mkdir backend\medical-service\src\main\java\com\hospital\medical\service 2>nul
mkdir backend\medical-service\src\main\java\com\hospital\medical\controller 2>nul
mkdir backend\medical-service\src\main\java\com\hospital\medical\dto 2>nul
mkdir backend\medical-service\src\main\resources 2>nul

mkdir database\init-scripts 2>nul
mkdir database\migrations 2>nul

mkdir frontend\src\components\Layout 2>nul
mkdir frontend\src\components\ProtectedRoute 2>nul
mkdir frontend\src\pages\Login 2>nul
mkdir frontend\src\pages\Dashboard 2>nul
mkdir frontend\src\pages\Patients 2>nul
mkdir frontend\src\pages\Appointments 2>nul
mkdir frontend\src\pages\Departments 2>nul
mkdir frontend\src\pages\MedicalRecords 2>nul
mkdir frontend\src\services 2>nul
mkdir frontend\src\store\slices 2>nul
mkdir frontend\src\utils 2>nul
mkdir frontend\src\hooks 2>nul
mkdir frontend\src\context 2>nul
mkdir frontend\public 2>nul

echo.
echo Directory structure created successfully!
echo.
echo Next steps:
echo 1. Run the PowerShell script: powershell -ExecutionPolicy Bypass -File create-files.ps1
echo 2. Or manually copy the files from the provided templates
echo.
pause