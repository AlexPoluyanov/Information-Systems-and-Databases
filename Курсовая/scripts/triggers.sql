-- Функция для получения всех фото по номеру
CREATE OR REPLACE FUNCTION get_car_photos(car_id VARCHAR)
RETURNS TABLE (
  photo_id INT,
  link VARCHAR(256),
  date DATE
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    photos.id AS photo_id,
    photos.link,
    photos.date
  FROM photos
  WHERE photos.car_num = car_id;
END;
$$ LANGUAGE plpgsql;

-- Функция для получения всех аварий по номеру
CREATE OR REPLACE FUNCTION get_car_crashes(car_id VARCHAR)
RETURNS TABLE (
  id INT,
  date DATE,
  description text
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    crashes.id AS crash_id,
    crashes.date,
    crashes.description
  FROM photos
  WHERE crashes.car_num = car_id;
END;
$$ LANGUAGE plpgsql;