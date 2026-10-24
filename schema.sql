-- DIIR MATCH — مخطط قاعدة البيانات MySQL / MariaDB
-- بلدية السوقر — ولاية تيارت
-- نفّذ هذا الملف على قاعدة بياناتك ثم اربط التطبيق بها.

CREATE DATABASE IF NOT EXISTS diir_match
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE diir_match;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  age TINYINT UNSIGNED DEFAULT 20,
  quarter VARCHAR(80) DEFAULT 'السوقر',
  whatsapp VARCHAR(20),
  position VARCHAR(80) DEFAULT 'مهاجم (FW)',
  photo LONGTEXT,
  xp INT UNSIGNED DEFAULT 0,
  matches_count INT UNSIGNED DEFAULT 0,
  pass VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stadiums (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  pin CHAR(4) NOT NULL,
  capacity TINYINT UNSIGNED DEFAULT 7,
  quarter VARCHAR(80) DEFAULT 'السوقر',
  image LONGTEXT,
  lat VARCHAR(24) DEFAULT '',
  lng VARCHAR(24) DEFAULT '',
  maps_url TEXT
);

CREATE TABLE IF NOT EXISTS bookings (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  field_id VARCHAR(40) NOT NULL,
  field_name VARCHAR(120) NOT NULL,
  user_id INT UNSIGNED,
  user_name VARCHAR(120),
  user_phone VARCHAR(20),
  booking_date DATE NOT NULL,
  booking_time CHAR(5) NOT NULL,
  status ENUM('pending','approved','rejected') DEFAULT 'pending',
  looking_for_team TINYINT(1) DEFAULT 0,
  notes TEXT,
  is_manual TINYINT(1) DEFAULT 0,
  created_at BIGINT,
  FOREIGN KEY (field_id) REFERENCES stadiums(id),
  INDEX idx_field_slot (field_id, booking_date, booking_time)
);

CREATE TABLE IF NOT EXISTS news (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(40) DEFAULT 'tourney',
  body TEXT,
  image LONGTEXT,
  is_alert TINYINT(1) DEFAULT 0,
  published_at VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS reports (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  from_user_id INT UNSIGNED,
  from_user_name VARCHAR(120),
  type VARCHAR(20),
  target_player VARCHAR(120),
  details TEXT,
  created_date VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS suggestions (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  user_id INT UNSIGNED,
  user_name VARCHAR(120),
  title VARCHAR(255),
  body TEXT,
  created_date VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS notices (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  field_id VARCHAR(40),
  field_name VARCHAR(120),
  title VARCHAR(255) NOT NULL,
  body TEXT,
  created_date VARCHAR(80)
);

CREATE TABLE IF NOT EXISTS notifications (
  id VARCHAR(60) NOT NULL PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  type VARCHAR(40) DEFAULT 'info',
  title VARCHAR(255) NOT NULL,
  body TEXT,
  booking_id VARCHAR(40),
  is_read TINYINT(1) DEFAULT 0,
  created_at BIGINT,
  INDEX idx_user_unread (user_id, is_read)
);

CREATE TABLE IF NOT EXISTS chat_messages (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  booking_id VARCHAR(40) NOT NULL,
  sender_id INT UNSIGNED,
  sender_name VARCHAR(120),
  is_me TINYINT(1) DEFAULT 0,
  text TEXT,
  sent_time VARCHAR(40),
  reactions JSON,
  INDEX idx_booking (booking_id)
);

CREATE TABLE IF NOT EXISTS admins (
  email VARCHAR(160) NOT NULL PRIMARY KEY,
  pass VARCHAR(255) NOT NULL,
  role VARCHAR(40) DEFAULT 'app_admin'
);

INSERT INTO admins (email, pass, role) VALUES
('fireabdou9@gmail.com', 'condor123', 'app_admin')
ON DUPLICATE KEY UPDATE pass = VALUES(pass);

INSERT INTO stadiums (id, name, pin, capacity, quarter, image, lat, lng) VALUES
('befok', 'ملعب بيفوك', '1111', 9, 'حي بيفوك', '/fields/befok.svg', '35.1855', '1.4962'),
('wilaya', 'ملعب الولاية', '2222', 9, 'حي الولاية', '/fields/wilaya.svg', '35.1868', '1.5011'),
('douk', 'ملعب الدوك', '3333', 7, 'حي الدوك', '/fields/douk.svg', '35.1812', '1.4924'),
('lacite', 'ملعب لاسيتي', '4444', 7, 'حي لاسيتي', '/fields/lacite.svg', '35.1798', '1.5056'),
('marhala2', 'ملعب المرحلة الثانية', '5555', 7, 'المرحلة الثانية', '/fields/marhala2.svg', '35.1901', '1.4988'),
('karya', 'ملعب القرية', '6666', 7, 'حي القرية', '/fields/karya.svg', '35.1774', '1.4889'),
('binaa', 'ملعب البناء الذاتي', '7777', 7, 'حي البناء الذاتي', '/fields/binaa.svg', '35.1882', '1.5102'),
('baraa', 'ملعب البراءة', '8888', 8, 'حي البراءة', '/fields/baraa.svg', '35.1749', '1.4941'),
('somal', 'ملعب الصومال', '9999', 7, 'حي الصومال', '/fields/somal.svg', '35.1915', '1.4876'),
('mejat', 'ملعب مجاط', '1010', 7, 'حي مجاط', '/fields/mejat.svg', '35.1826', '1.5128'),
('hamri', 'ملعب الحمري', '1212', 7, 'حي الحمري', '/fields/hamri.svg', '35.1761', '1.5033'),
('ikhwa', 'ملعب الإخوة (كوسوفو)', '1313', 9, 'حي كوسوفو', '/fields/ikhwa.svg', '35.1933', '1.5067'),
('csp', 'ملعب CSP', '1414', 9, 'مركب CSP السوقر', '/fields/csp.svg', '35.1844', '1.4992')
ON DUPLICATE KEY UPDATE name = VALUES(name), pin = VALUES(pin), image = VALUES(image), lat = VALUES(lat), lng = VALUES(lng);
