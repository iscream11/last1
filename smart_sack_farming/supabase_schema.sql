-- ============================================================
-- Smart Sack Farming - Complete Supabase Database Schema
-- ============================================================
-- Instructions:
--   1. Go to your Supabase project → SQL Editor → New Query
--   2. Paste this ENTIRE file
--   3. Click "Run"
-- ============================================================

-- ============================================================
-- SECTION 1: TABLES
-- ============================================================

-- 1. User Profiles (extends Supabase Auth)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  full_name VARCHAR(255),
  role VARCHAR(20) NOT NULL DEFAULT 'farmer',
  phone VARCHAR(50),
  address TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_profiles_email ON profiles(email);

-- 2. Farming Projects
CREATE TABLE IF NOT EXISTS farming_projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  crop_type VARCHAR(100) NOT NULL,
  area DECIMAL(10, 2) NOT NULL,
  planting_date TIMESTAMPTZ NOT NULL,
  harvest_date TIMESTAMPTZ NOT NULL,
  revenue DECIMAL(15, 2) NOT NULL DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_farming_projects_user_id ON farming_projects(user_id);
CREATE INDEX idx_farming_projects_status ON farming_projects(status);

-- 3. Expenses (linked to farming projects)
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES farming_projects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category VARCHAR(100) NOT NULL,
  description TEXT,
  amount DECIMAL(12, 2) NOT NULL,
  date TIMESTAMPTZ NOT NULL,
  phase VARCHAR(20) NOT NULL DEFAULT 'planting',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_expenses_project_id ON expenses(project_id);
CREATE INDEX idx_expenses_user_id ON expenses(user_id);
CREATE INDEX idx_expenses_date ON expenses(date);

-- 4. Equipment (for rental marketplace)
CREATE TABLE IF NOT EXISTS equipment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100) NOT NULL,
  daily_rental_price DECIMAL(10, 2) NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  condition VARCHAR(50) NOT NULL DEFAULT 'good',
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  image_url TEXT,
  owner_name VARCHAR(255),
  owner_phone VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_equipment_owner_id ON equipment(owner_id);
CREATE INDEX idx_equipment_category ON equipment(category);

-- 5. Calamity Reports
CREATE TABLE IF NOT EXISTS calamity_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type VARCHAR(100) NOT NULL,
  severity VARCHAR(20) NOT NULL DEFAULT 'medium',
  date TIMESTAMPTZ NOT NULL,
  area_affected DECIMAL(10, 2),
  affected_crops TEXT,
  description TEXT,
  damage_estimate DECIMAL(15, 2) DEFAULT 0,
  farmer_name VARCHAR(255),
  image_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'reported',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_calamity_reports_user_id ON calamity_reports(user_id);
CREATE INDEX idx_calamity_reports_type ON calamity_reports(type);
CREATE INDEX idx_calamity_reports_date ON calamity_reports(date);

-- 6. Production Reports
CREATE TABLE IF NOT EXISTS production_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  crop_type VARCHAR(100) NOT NULL,
  area DECIMAL(10, 2) NOT NULL,
  planting_date TIMESTAMPTZ NOT NULL,
  harvest_date TIMESTAMPTZ NOT NULL,
  yield DECIMAL(12, 2) NOT NULL,
  yield_unit VARCHAR(50) NOT NULL DEFAULT 'kg',
  quality_rating INTEGER CHECK (quality_rating >= 1 AND quality_rating <= 5),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_production_reports_user_id ON production_reports(user_id);
CREATE INDEX idx_production_reports_crop_type ON production_reports(crop_type);

-- ============================================================
-- SECTION 2: ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE farming_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE calamity_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE production_reports ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 3: RLS POLICIES
-- ============================================================

-- Profiles Policies
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Farming Projects Policies
CREATE POLICY "Users can view own projects"
  ON farming_projects FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own projects"
  ON farming_projects FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects"
  ON farming_projects FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own projects"
  ON farming_projects FOR DELETE
  USING (auth.uid() = user_id);

-- Expenses Policies
CREATE POLICY "Users can view own expenses"
  ON expenses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses"
  ON expenses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses"
  ON expenses FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses"
  ON expenses FOR DELETE
  USING (auth.uid() = user_id);

-- Equipment Policies (anyone can view, only owner can modify)
CREATE POLICY "Anyone can view equipment"
  ON equipment FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own equipment"
  ON equipment FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own equipment"
  ON equipment FOR UPDATE
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own equipment"
  ON equipment FOR DELETE
  USING (auth.uid() = owner_id);

-- Calamity Reports Policies
CREATE POLICY "Users can view own calamity reports"
  ON calamity_reports FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own calamity reports"
  ON calamity_reports FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own calamity reports"
  ON calamity_reports FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own calamity reports"
  ON calamity_reports FOR DELETE
  USING (auth.uid() = user_id);

-- Production Reports Policies
CREATE POLICY "Users can view own production reports"
  ON production_reports FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own production reports"
  ON production_reports FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own production reports"
  ON production_reports FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own production reports"
  ON production_reports FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================
-- SECTION 4: AUTO-CREATE PROFILE ON SIGNUP (TRIGGER)
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- SECTION 5: AUTO-UPDATE updated_at COLUMNS (TRIGGER)
-- ============================================================

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_farming_projects_updated_at
  BEFORE UPDATE ON farming_projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at
  BEFORE UPDATE ON expenses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_equipment_updated_at
  BEFORE UPDATE ON equipment
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_calamity_reports_updated_at
  BEFORE UPDATE ON calamity_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_production_reports_updated_at
  BEFORE UPDATE ON production_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- SECTION 6: STORAGE BUCKET FOR IMAGES (optional)
-- ============================================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('farm-images', 'farm-images', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Anyone can view farm images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'farm-images');

CREATE POLICY "Authenticated users can upload farm images"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'farm-images' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update own farm images"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'farm-images' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own farm images"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'farm-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================================
-- DONE! Your database is ready.
-- ============================================================
