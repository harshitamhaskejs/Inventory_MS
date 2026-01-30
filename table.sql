-- Create users table
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  role TEXT CHECK (role IN ('admin', 'instructor')) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create schools table with user_id foreign key
CREATE TABLE schools (
  school_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(user_id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  start_deadline DATE,
  end_deadline DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create kits table
CREATE TABLE kits (
  kit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID REFERENCES schools(school_id) ON DELETE CASCADE,
  name TEXT,
  status TEXT CHECK (status IN ('pending', 'complete', 'issues')) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create parts table (predefined LEGO parts)
CREATE TABLE parts (
  part_id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  name TEXT NOT NULL,
  expected INT NOT NULL,
  icon TEXT
);

-- Create part_counts table (directly linked to kit)
CREATE TABLE part_counts (
  kit_id UUID REFERENCES kits(kit_id) ON DELETE CASCADE,
  part_id TEXT REFERENCES parts(part_id),
  start_actual INT,
  end_actual INT,
  PRIMARY KEY (kit_id, part_id)
);

-- Insert all the predefined LEGO Spike Prime parts
INSERT INTO parts (part_id, category, name, expected, icon) VALUES
('large_hub', 'Electronics', 'Large Hub', 1, '⚡'),
('hub_battery', 'Electronics', 'Hub Battery', 1, '⚡'),
('medium_motor', 'Electronics', 'Medium Motor', 2, '⚡'),
('large_motor', 'Electronics', 'Large Motor', 1, '⚡'),
('color_sensor', 'Electronics', 'Color Sensor', 1, '⚡'),
('distance_sensor', 'Electronics', 'Distance Sensor', 1, '⚡'),
('force_sensor', 'Electronics', 'Force Sensor', 1, '⚡'),
('micro_usb', 'Electronics', 'USB Cable', 1, '⚡'),
('beam_3m', 'Beams', 'Beam 3M', 6, '🔧'),
('beam_5m', 'Beams', 'Beam 5M', 4, '🔧'),
('beam_7m', 'Beams', 'Beam 7M', 6, '🔧'),
('beam_9m', 'Beams', 'Beam 9M', 4, '🔧'),
('beam_11m', 'Beams', 'Beam 11M', 4, '🔧'),
('beam_13m', 'Beams', 'Beam 13M', 4, '🔧'),
('beam_15m', 'Beams', 'Beam 15M', 6, '🔧'),
('frame_5x7', 'Frames', 'Frame 5×7', 2, '⬜'),
('frame_7x11', 'Frames', 'Frame 7×11', 2, '⬜'),
('frame_11x15', 'Frames', 'Frame 11×15', 1, '⬜'),
('peg_black', 'Connectors', 'Black Pegs', 72, '🔩'),
('peg_blue', 'Connectors', 'Blue Pegs', 20, '🔩'),
('bush', 'Connectors', 'Bush', 10, '🔩'),
('wheel_56', 'Wheels & Gears', 'Wheel Ø56', 4, '⚙️'),
('gear_12', 'Wheels & Gears', 'Gear Z12', 2, '⚙️'),
('gear_20', 'Wheels & Gears', 'Gear Z20', 2, '⚙️'),
('gear_36', 'Wheels & Gears', 'Gear Z36', 2, '⚙️'),
('minifig_kate', 'Miscellaneous', 'Kate Minifigure', 1, '📦'),
('minifig_kyle', 'Miscellaneous', 'Kyle Minifigure', 1, '📦'),
('storage_box', 'Miscellaneous', 'Storage Box', 1, '📦'),
('sorting_trays', 'Miscellaneous', 'Sorting Trays', 2, '📦');

-- =============================================
-- ROW LEVEL SECURITY (RLS) SETUP
-- =============================================

-- Enable Row Level Security on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;
ALTER TABLE kits ENABLE ROW LEVEL SECURITY;
ALTER TABLE parts ENABLE ROW LEVEL SECURITY;
ALTER TABLE part_counts ENABLE ROW LEVEL SECURITY;

-- Create public access policies (allows anonymous access)
-- Use this since app uses hardcoded passwords instead of Supabase Auth

CREATE POLICY "Enable all for anon" ON users 
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all for anon" ON schools 
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all for anon" ON kits 
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all for anon" ON part_counts 
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable read for anon" ON parts 
  FOR SELECT USING (true);