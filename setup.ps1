# 1. تثبيت الحزم
Write-Host "[1/5] Installing Dependencies..." -ForegroundColor Cyan
npm install

# 2. إنشاء ملف .env.local تلقائياً
Write-Host "[2/5] Creating .env.local..." -ForegroundColor Cyan
Set-Content -Path ".env.local" -Value 'DATABASE_URL="postgresql://postgres:postgres@127.0.0.1:5432/app_db"'

# 3. تشغيل حاوية PostgreSQL عبر Docker
Write-Host "[3/5] Starting PostgreSQL Container..." -ForegroundColor Cyan
$containerExists = docker ps -a -q -f name=postgres-app
if ($containerExists) {
    docker start postgres-app
} else {
    docker run --name postgres-app -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=app_db -p 5432:5432 -d postgres
}

# 4. الانتظار حتى جاهزية الخادم للمحاكاة وتطبيق Drizzle Kit
Write-Host "[4/5] Waiting for Database and Pushing Schema..." -ForegroundColor Cyan
Start-Sleep -Seconds 3
npx drizzle-kit push

# 5. تشغيل مشروع Next.js
Write-Host "[5/5] Launching Next.js App..." -ForegroundColor Green
npm run dev