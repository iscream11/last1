# Smart Sack Farming - Complete Database Setup

## Step 1: Create Users Profile Table

Paste this in Supabase SQL Editor and click **Run**:

```sql
-- Create users profile table (stores additional user info)
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR NOT NULL UNIQUE,
  full_name VARCHAR,
  role VARCHAR NOT NULL DEFAULT 'farmer', -- 'farmer' or 'admin'
  phone VARCHAR,
  address VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view/update their own profile
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

## Step 2: Create Farming Projects & Expenses Tables

Paste this and click **Run**:

```sql
-- Farming projects table
CREATE TABLE farming_projects (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  crop_type VARCHAR NOT NULL,
  area NUMERIC NOT NULL,
  planting_date TIMESTAMP NOT NULL,
  harvest_date TIMESTAMP NOT NULL,
  revenue NUMERIC DEFAULT 0,
  status VARCHAR DEFAULT 'active',
  created_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Expenses table
CREATE TABLE expenses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  project_id UUID NOT NULL REFERENCES farming_projects(id) ON DELETE CASCADE,
  category VARCHAR NOT NULL,
  description TEXT,
  amount NUMERIC NOT NULL,
  date TIMESTAMP NOT NULL,
  phase VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE farming_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- RLS Policies for farming_projects
CREATE POLICY "Users can view own projects" ON farming_projects
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own projects" ON farming_projects
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects" ON farming_projects
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own projects" ON farming_projects
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for expenses
CREATE POLICY "Users can view own expenses" ON expenses
  FOR SELECT USING (
    project_id IN (
      SELECT id FROM farming_projects WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own expenses" ON expenses
  FOR INSERT WITH CHECK (
    project_id IN (
      SELECT id FROM farming_projects WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own expenses" ON expenses
  FOR UPDATE USING (
    project_id IN (
      SELECT id FROM farming_projects WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own expenses" ON expenses
  FOR DELETE USING (
    project_id IN (
      SELECT id FROM farming_projects WHERE user_id = auth.uid()
    )
  );
```

## Step 3: Create Equipment Rentals Table

```sql
CREATE TABLE equipment (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  description TEXT,
  daily_rental_price NUMERIC NOT NULL,
  availability BOOLEAN DEFAULT TRUE,
  created_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view equipment" ON equipment
  FOR SELECT USING (TRUE);

CREATE POLICY "Users can insert own equipment" ON equipment
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own equipment" ON equipment
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own equipment" ON equipment
  FOR DELETE USING (auth.uid() = user_id);
```

## Step 4: Create Reports Tables

```sql
CREATE TABLE calamity_reports (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  crop_type VARCHAR NOT NULL,
  calamity_type VARCHAR NOT NULL, -- flood, drought, pest, disease, etc
  description TEXT,
  affected_area NUMERIC,
  latitude NUMERIC,
  longitude NUMERIC,
  damage_percentage NUMERIC,
 created_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE production_reports (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  crop_type VARCHAR NOT NULL,
  area_planted NUMERIC NOT NULL,
  yield_quantity NUMERIC NOT NULL,
  yield_unit VARCHAR DEFAULT 'kg',
  quality_rating NUMERIC, -- 1-5
  market_price NUMERIC,
  production_date TIMESTAMP NOT NULL,
  created_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE calamity_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE production_reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own calamity reports" ON calamity_reports
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert calamity reports" ON calamity_reports
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own calamity reports" ON calamity_reports
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own calamity reports" ON calamity_reports
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own production reports" ON production_reports
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert production reports" ON production_reports
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own production reports" ON production_reports
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own production reports" ON production_reports
  FOR DELETE USING (auth.uid() = user_id);
```

## Quick Setup Order:
1. Run Step 1 SQL ✅
2. Run Step 2 SQL ✅
3. Run Step 3 SQL ✅
4. Run Step 4 SQL ✅

**Then restart your Flutter app!**

The app will now:
- ✅ Store login accounts in Supabase Auth
- ✅ Keep all data persistent in the database
- ✅ Show data across sessions when logged in
- ✅ Isolate user data with RLS policies
