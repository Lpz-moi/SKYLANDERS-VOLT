/*
  # Skylanders Collection Management Schema

  ## Overview
  This migration creates the complete database schema for the Skylanders collection management application.

  ## Tables Created
  
  ### 1. skylanders
  - `id` (uuid, primary key) - Unique identifier for each Skylander
  - `name` (text) - Name of the Skylander
  - `element` (text) - Element type (Fire, Water, Earth, Air, Life, Magic, Tech, Undead)
  - `game` (text) - Game of origin (Spyro's Adventure, Giants, Swap Force, etc.)
  - `rarity` (text) - Rarity level (Common, Rare, Ultra Rare, Legendary)
  - `image_url` (text) - URL to the Skylander's image
  - `type` (text) - Type category (Core, Giant, Swapper, Trap Master, etc.)
  - `created_at` (timestamptz) - Record creation timestamp

  ### 2. user_collections
  - `id` (uuid, primary key) - Unique identifier for collection entry
  - `user_id` (uuid) - Reference to auth.users
  - `skylander_id` (uuid) - Reference to skylanders table
  - `owned` (boolean) - Whether user owns this Skylander
  - `notes` (text) - Optional user notes
  - `created_at` (timestamptz) - When added to collection
  - `updated_at` (timestamptz) - Last modification time

  ## Security
  - Enable RLS on all tables
  - Users can only read all Skylanders data
  - Users can only manage their own collection entries
  - Authenticated users required for collection management

  ## Indexes
  - Index on user_id for fast collection queries
  - Index on skylander_id for lookups
  - Unique constraint on (user_id, skylander_id) to prevent duplicates
*/

-- Create skylanders table
CREATE TABLE IF NOT EXISTS skylanders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  element text NOT NULL,
  game text NOT NULL,
  rarity text NOT NULL DEFAULT 'Common',
  image_url text NOT NULL,
  type text NOT NULL DEFAULT 'Core',
  created_at timestamptz DEFAULT now()
);

-- Create user_collections table
CREATE TABLE IF NOT EXISTS user_collections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  skylander_id uuid NOT NULL REFERENCES skylanders(id) ON DELETE CASCADE,
  owned boolean DEFAULT true,
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, skylander_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_collections_user_id ON user_collections(user_id);
CREATE INDEX IF NOT EXISTS idx_user_collections_skylander_id ON user_collections(skylander_id);
CREATE INDEX IF NOT EXISTS idx_skylanders_element ON skylanders(element);
CREATE INDEX IF NOT EXISTS idx_skylanders_game ON skylanders(game);

-- Enable Row Level Security
ALTER TABLE skylanders ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_collections ENABLE ROW LEVEL SECURITY;

-- RLS Policies for skylanders table
CREATE POLICY "Anyone can view Skylanders"
  ON skylanders FOR SELECT
  TO authenticated, anon
  USING (true);

-- RLS Policies for user_collections table
CREATE POLICY "Users can view own collection"
  ON user_collections FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert into own collection"
  ON user_collections FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own collection"
  ON user_collections FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete from own collection"
  ON user_collections FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_user_collections_updated_at
  BEFORE UPDATE ON user_collections
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert initial Skylanders data (representative set from all games)
INSERT INTO skylanders (name, element, game, rarity, image_url, type) VALUES 
  ('Spyro', 'Magic', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Spyro.png', 'Core'),
  ('Gill Grunt', 'Water', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/GillGrunt.png', 'Core'),
  ('Trigger Happy', 'Tech', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/TriggerHappy.png', 'Core'),
  ('Eruptor', 'Fire', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Eruptor.png', 'Core'),
  ('Stealth Elf', 'Life', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/StealthElf.png', 'Core'),
  ('Bash', 'Earth', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Bash.png', 'Core'),
  ('Chop Chop', 'Undead', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/ChopChop.png', 'Core'),
  ('Lightning Rod', 'Air', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LightningRod.png', 'Core'),
  ('Prism Break', 'Magic', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/PrismBreak.png', 'Core'),
  ('Slam Bam', 'Water', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/SlamBam.png', 'Core'),
  ('Drobot', 'Tech', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Drobot.png', 'Core'),
  ('Flameslinger', 'Fire', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Flameslinger.png', 'Core'),
  ('Zook', 'Life', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Zook.png', 'Core'),
  ('Dino-Rang', 'Earth', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/DinoRang.png', 'Core'),
  ('Ghost Roaster', 'Undead', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/GhostRoaster.png', 'Core'),
  ('Sonic Boom', 'Air', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/SonicBoom.png', 'Core'),
  ('Double Trouble', 'Magic', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/DoubleTrouble.png', 'Core'),
  ('Wham-Shell', 'Water', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/WhamShell.png', 'Core'),
  ('Boomer', 'Tech', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Boomer.png', 'Core'),
  ('Ignitor', 'Fire', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Ignitor.png', 'Core'),
  ('Camo', 'Life', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Camo.png', 'Core'),
  ('Terrafin', 'Earth', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Terrafin.png', 'Core'),
  ('Hex', 'Undead', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Hex.png', 'Core'),
  ('Whirlwind', 'Air', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Whirlwind.png', 'Core'),
  ('Voodood', 'Magic', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Voodood.png', 'Core'),
  ('Zap', 'Water', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Zap.png', 'Core'),
  ('Drill Sergeant', 'Tech', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/DrillSergeant.png', 'Core'),
  ('Sunburn', 'Fire', 'Spyro''s Adventure', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Sunburn.png', 'Core'),
  ('Stump Smash', 'Life', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/StumpSmash.png', 'Core'),
  ('Prism Break', 'Earth', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/PrismBreak.png', 'Core'),
  ('Cynder', 'Undead', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Cynder.png', 'Core'),
  ('Warnado', 'Air', 'Spyro''s Adventure', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Warnado.png', 'Core'),

-- GIANTS (2012)
  ('Tree Rex', 'Life', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/TreeRex.png', 'Giant'),
  ('Crusher', 'Earth', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Crusher.png', 'Giant'),
  ('Bouncer', 'Tech', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Bouncer.png', 'Giant'),
  ('Hot Head', 'Fire', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/HotHead.png', 'Giant'),
  ('Eye-Brawl', 'Undead', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/EyeBrawl.png', 'Giant'),
  ('Swarm', 'Air', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Swarm.png', 'Giant'),
  ('Ninjini', 'Magic', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Ninjini.png', 'Giant'),
  ('Thumpback', 'Water', 'Giants', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Thumpback.png', 'Giant'),
  ('Jet-Vac', 'Air', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/JetVac.png', 'Core'),
  ('Pop Fizz', 'Magic', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/PopFizz.png', 'Core'),
  ('Fright Rider', 'Undead', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/FrightRider.png', 'Core'),
  ('Shroomboom', 'Life', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Shroomboom.png', 'Core'),
  ('Flashwing', 'Earth', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Flashwing.png', 'Core'),
  ('Hot Dog', 'Fire', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/HotDog.png', 'Core'),
  ('Chill', 'Water', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Chill.png', 'Core'),
  ('Sprocket', 'Tech', 'Giants', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/Sprocket.png', 'Core'),

-- SWAP FORCE (2013)
  ('Wash Buckler', 'Water', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/WashBuckler.png', 'Swapper'),
  ('Magna Charge', 'Tech', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/MagnaCharge.png', 'Swapper'),
  ('Blast Zone', 'Fire', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/BlastZone.png', 'Swapper'),
  ('Doom Stone', 'Earth', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/DoomStone.png', 'Swapper'),
  ('Night Shift', 'Undead', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/NightShift.png', 'Swapper'),
  ('Free Ranger', 'Air', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/FreeRanger.png', 'Swapper'),
  ('Hoot Loop', 'Magic', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/HootLoop.png', 'Swapper'),
  ('Grilla Drilla', 'Life', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/GrillaDrilla.png', 'Swapper'),
  ('Rattle Shake', 'Undead', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/RattleShake.png', 'Swapper'),
  ('Fire Kraken', 'Fire', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/FireKraken.png', 'Swapper'),
  ('Stink Bomb', 'Life', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/StinkBomb.png', 'Swapper'),
  ('Freeze Blade', 'Water', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/FreezeBlade.png', 'Swapper'),
  ('Rubble Rouser', 'Earth', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/RubbleRouser.png', 'Swapper'),
  ('Boom Jet', 'Air', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/BoomJet.png', 'Swapper'),
  ('Spy Rise', 'Tech', 'Swap Force', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/SpyRise.png', 'Swapper'),
  ('Star Strike', 'Magic', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/StarStrike.png', 'Core'),
  ('Countdown', 'Tech', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/Countdown.png', 'Core'),
  ('Scorp', 'Earth', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/Scorp.png', 'Core'),
  ('Roller Brawl', 'Undead', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/RollerBrawl.png', 'Core'),
  ('Grim Creeper', 'Undead', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/GrimCreeper.png', 'Core'),
  ('Rip Tide', 'Water', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/RipTide.png', 'Core'),
  ('Punk Shock', 'Water', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/PunkShock.png', 'Core'),
  ('Fryno', 'Fire', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/Fryno.png', 'Core'),
  ('Smolderdash', 'Fire', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/Smolderdash.png', 'Core'),
  ('Bumble Blast', 'Life', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/BumbleBlast.png', 'Core'),
  ('Zoo Lou', 'Life', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/ZooLou.png', 'Core'),
  ('Slobber Tooth', 'Earth', 'Swap Force', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/SlobberTooth.png', 'Core'),

-- TRAP TEAM (2014)
  ('Snap Shot', 'Water', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/SnapShot.png', 'Trap Master'),
  ('Wildfire', 'Fire', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Wildfire.png', 'Trap Master'),
  ('Wallop', 'Earth', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Wallop.png', 'Trap Master'),
  ('Head Rush', 'Air', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/HeadRush.png', 'Trap Master'),
  ('Krypt King', 'Undead', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/KryptKing.png', 'Trap Master'),
  ('Jawbreaker', 'Tech', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Jawbreaker.png', 'Trap Master'),
  ('Ka-Boom', 'Magic', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/KaBoom.png', 'Trap Master'),
  ('Bushwhack', 'Life', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Bushwhack.png', 'Trap Master'),
  ('Lob-Star', 'Water', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/LobStar.png', 'Trap Master'),
  ('Torch', 'Fire', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Torch.png', 'Trap Master'),
  ('Trail Blazer', 'Tech', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/TrailBlazer.png', 'Trap Master'),
  ('Gusto', 'Air', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Gusto.png', 'Trap Master'),
  ('Blastermind', 'Magic', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Blastermind.png', 'Trap Master'),
  ('Tuff Luck', 'Life', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/TuffLuck.png', 'Trap Master'),
  ('Rocky Roll', 'Earth', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/RockyRoll.png', 'Trap Master'),
  ('Short Cut', 'Undead', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/ShortCut.png', 'Trap Master'),
  ('Funny Bone', 'Undead', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/FunnyBone.png', 'Core'),
  ('Chopper', 'Tech', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Chopper.png', 'Core'),
  ('Tread Head', 'Earth', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/TreadHead.png', 'Core'),
  ('Fist Bump', 'Earth', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/FistBump.png', 'Core'),
  ('Gearshift', 'Tech', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Gearshift.png', 'Core'),
  ('Bat Spin', 'Undead', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/BatSpin.png', 'Core'),
  ('Flip Wreck', 'Water', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/FlipWreck.png', 'Core'),
  ('Echo', 'Water', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Echo.png', 'Core'),
  ('Blades', 'Air', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Blades.png', 'Core'),
  ('Cobra Cadabra', 'Magic', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/CobraCadabra.png', 'Core'),
  ('Enigma', 'Magic', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Enigma.png', 'Core'),
  ('Deja Vu', 'Magic', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/DejaVu.png', 'Core'),
  ('Gill Grunt', 'Water', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/MiniGillGrunt.png', 'Mini'),
  ('Trigger Happy', 'Tech', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/MiniTriggerHappy.png', 'Mini'),
  ('Spyro', 'Magic', 'Trap Team', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/MiniSpyro.png', 'Mini'),
  ('Kaos', 'Dark', 'Trap Team', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/Kaos.png', 'Villain'),

-- SUPERCHARGERS (2015)
  ('Spitfire', 'Fire', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Spitfire.png', 'SuperCharger'),
  ('Hurricane Jet-Vac', 'Air', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/HurricaneJetVac.png', 'SuperCharger'),
  ('Dive-Clops', 'Water', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DiveClops.png', 'SuperCharger'),
  ('Terrafin', 'Earth', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/SuperChargersTerrafin.png', 'SuperCharger'),
  ('Stealth Elf', 'Life', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/SuperChargersStealthElf.png', 'SuperCharger'),
  ('Super Shot Stealth Elf', 'Life', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/SuperShotStealthElf.png', 'SuperCharger'),
  ('Stormblade', 'Air', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Stormblade.png', 'SuperCharger'),
  ('Fiesta', 'Undead', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Fiesta.png', 'SuperCharger'),
  ('Splat', 'Magic', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Splat.png', 'SuperCharger'),
  ('Thrillipede', 'Life', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Thrillipede.png', 'SuperCharger'),
  ('Nightfall', 'Dark', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Nightfall.png', 'SuperCharger'),
  ('Double Dare Trigger Happy', 'Tech', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DoubleDareTriggerHappy.png', 'SuperCharger'),
  ('Big Bubble Pop Fizz', 'Magic', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/BigBubblePopFizz.png', 'SuperCharger'),
  ('Lava Lance Eruptor', 'Fire', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/LavaLanceEruptor.png', 'SuperCharger'),
  ('Deep Dive Gill Grunt', 'Water', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DeepDiveGillGrunt.png', 'SuperCharger'),
  ('High Volt', 'Tech', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/HighVolt.png', 'SuperCharger'),
  ('Smash Hit', 'Earth', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/SmashHit.png', 'SuperCharger'),
  ('Astroblast', 'Light', 'SuperChargers', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Astroblast.png', 'SuperCharger'),
  ('Bowser', 'Fire', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/Bowser.png', 'Guest'),
  ('Donkey Kong', 'Life', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DonkeyKong.png', 'Guest'),
  ('Hammer Slam Bowser', 'Fire', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/HammerSlamBowser.png', 'Guest'),
  ('Turbo Charge Donkey Kong', 'Life', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/TurboChargeDonkeyKong.png', 'Guest'),

-- IMAGINATORS (2016)
  ('King Pen', 'Water', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/KingPen.png', 'Sensei'),
  ('Wild Storm', 'Air', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/WildStorm.png', 'Sensei'),
  ('Tri-Tip', 'Tech', 'Imaginators', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/TriTip.png', 'Sensei'),
  ('Barbella', 'Earth', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Barbella.png', 'Sensei'),
  ('Ember', 'Fire', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Ember.png', 'Sensei'),
  ('Wolfgang', 'Undead', 'Imaginators', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Wolfgang.png', 'Sensei'),
  ('Golden Queen', 'Magic', 'Imaginators', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/GoldenQueen.png', 'Sensei'),
  ('Pit Boss', 'Undead', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/PitBoss.png', 'Sensei'),
  ('Ambush', 'Life', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Ambush.png', 'Sensei'),
  ('Chopscotch', 'Magic', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Chopscotch.png', 'Sensei'),
  ('Crash Bandicoot', 'Life', 'Imaginators', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/CrashBandicoot.png', 'Guest'),
  ('Dr. Neo Cortex', 'Tech', 'Imaginators', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/DrNeoCortex.png', 'Guest'),
  ('Tae Kwon Crow', 'Air', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/TaeKwonCrow.png', 'Sensei'),
  ('Buckshot', 'Earth', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Buckshot.png', 'Sensei'),
  ('Starcast', 'Magic', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Starcast.png', 'Sensei'),
  ('Chain Reaction', 'Tech', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/ChainReaction.png', 'Sensei'),
  ('Grave Clobber', 'Undead', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/GraveClobber.png', 'Sensei'),
  ('Blaster-Tron', 'Tech', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/BlasterTron.png', 'Sensei'),
  ('Mysticat', 'Magic', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Mysticat.png', 'Sensei'),
  ('Pain-Yatta', 'Fire', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/PainYatta.png', 'Sensei'),
  ('Flare Wolf', 'Fire', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/FlareWolf.png', 'Sensei'),
  ('Chompy Mage', 'Life', 'Imaginators', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/ChompyMage.png', 'Villain Sensei'),
  ('Hood Sickle', 'Undead', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/HoodSickle.png', 'Sensei'),
  ('Tidepool', 'Water', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/Tidepool.png', 'Sensei'),
  ('Dr. Krankcase', 'Tech', 'Imaginators', 'Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/DrKrankcase.png', 'Sensei'),
  ('Boom Bloom', 'Life', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/BoomBloom.png', 'Sensei'),
  ('Ro-Bow', 'Tech', 'Imaginators', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/RoBow.png', 'Sensei'),
  ('Air Strike', 'Air', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/AirStrike.png', 'Sensei'),
  ('Bad Juju', 'Magic', 'Imaginators', 'Common', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/BadJuju.png', 'Sensei'),
  ('Kaos', 'Dark', 'Imaginators', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2016/05/ImaginatorsKaos.png', 'Sensei'),
  
-- Variantes légendaires et spéciales
  ('Legendary Spyro', 'Magic', 'Spyro''s Adventure', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendarySpyro.png', 'Core'),
  ('Dark Spyro', 'Magic', 'Spyro''s Adventure', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/DarkSpyro.png', 'Core'),
  ('Legendary Trigger Happy', 'Tech', 'Spyro''s Adventure', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryTriggerHappy.png', 'Core'),
  ('Legendary Bash', 'Earth', 'Spyro''s Adventure', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryBash.png', 'Core'),
  ('Legendary Chop Chop', 'Undead', 'Spyro''s Adventure', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryChopChop.png', 'Core'),
  ('Legendary Slam Bam', 'Water', 'Giants', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendarySlamBam.png', 'Core'),
  ('Legendary Stealth Elf', 'Life', 'Giants', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryStealthElf.png', 'Core'),
  ('Legendary Bouncer', 'Tech', 'Giants', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryBouncer.png', 'Giant'),
  ('Legendary Jet-Vac', 'Air', 'Giants', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryJetVac.png', 'Core'),
  ('Legendary Chill', 'Water', 'Giants', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/02/LegendaryChill.png', 'Core'),
  ('Legendary Free Ranger', 'Air', 'Swap Force', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/LegendaryFreeRanger.png', 'Swapper'),
  ('Legendary Night Shift', 'Undead', 'Swap Force', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/LegendaryNightShift.png', 'Swapper'),
  ('Legendary Zoo Lou', 'Life', 'Swap Force', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2013/10/LegendaryZooLou.png', 'Core'),
  ('Legendary Jawbreaker', 'Tech', 'Trap Team', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/LegendaryJawbreaker.png', 'Trap Master'),
  ('Legendary Bushwhack', 'Life', 'Trap Team', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/LegendaryBushwhack.png', 'Trap Master'),
  ('Nitro Krypt King', 'Undead', 'Trap Team', 'Ultra Rare', 'https://skylanderscharacterlist.com/wp-content/uploads/2014/06/NitroKryptKing.png', 'Trap Master'),
  ('Legendary Bone Bash Roller Brawl', 'Undead', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/LegendaryBoneBashRollerBrawl.png', 'SuperCharger'),
  ('Dark Spitfire', 'Fire', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DarkSpitfire.png', 'SuperCharger'),
  ('Dark Turbo Charge Donkey Kong', 'Life', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DarkTurboChargeDonkeyKong.png', 'Guest'),
  ('Dark Hammer Slam Bowser', 'Fire', 'SuperChargers', 'Legendary', 'https://skylanderscharacterlist.com/wp-content/uploads/2015/07/DarkHammerSlamBowser.png', 'Guest')
ON CONFLICT DO NOTHING;