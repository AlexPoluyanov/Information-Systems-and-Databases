-- Заполнение таблиц данными вручную
INSERT INTO users(name, surname, username, phone, hash, salt) 
SELECT (CASE floor(random() * 7)::INT
            WHEN 0 THEN 'Alex'
            WHEN 1 THEN 'Nik'
            WHEN 2 THEN 'Kirya'
            WHEN 3 THEN 'Sergey'
            WHEN 4 THEN 'Victor'
            WHEN 5 THEN 'Evgeniy'
            WHEN 6 THEN 'Dima'
           END),
       (CASE floor(random() * 5)::INT
            WHEN 0 THEN 'Poluyanov'
            WHEN 1 THEN 'Sagaydak'
            WHEN 2 THEN 'Popov'
            WHEN 3 THEN 'Kulakov'
            WHEN 4 THEN 'Sheshukov'
           END),
       'UserNumber' || generate_series,
       '+7909' || 9999999 - generate_series,
        md5(('+7909' || 9999999 - generate_series || generate_series)::TEXT),
        md5(generate_series::text)
FROM generate_series(1, 100000);


-- Создание машин
INSERT INTO cars(car_num, num_type, year_of_issue, color, car_body_type, transmission, wheel_drive_type, rudder
) 
SELECT LPAD((floor(random() * 98 + 1)::int)::text ,2,'0') || chr(floor(random() * 26)::INT + 97) || LPAD((10 % 1000)::text ,3,'0')  || chr(floor(random() * 26)::INT + 97) || chr(floor(random() * 26)::INT + 97),
        (CASE floor(random() * 6)::INT
            WHEN 0 THEN 'individual'
            WHEN 1 THEN 'legal entity'
            WHEN 2 THEN 'forigner citizen'
            WHEN 3 THEN 'army'
            WHEN 4 THEN 'individual'
            WHEN 5 THEN 'legal entity'
           END)::num_type,
       (1990 + floor(random() * 33)::int),
       (CASE floor(random() * 12)::INT
            WHEN 0 THEN 'white'
            WHEN 1 THEN 'red'
            WHEN 2 THEN 'yellow'
            WHEN 3 THEN 'black'
            WHEN 4 THEN 'blue'
            WHEN 5 THEN 'pink'
            WHEN 6 THEN 'orange'
            WHEN 7 THEN 'green'
            WHEN 8 THEN 'violet'
            WHEN 9 THEN 'purple'
            WHEN 10 THEN 'silver'
            WHEN 11 THEN 'metalic'
           END),
        (CASE floor(random() * 15)::INT
            WHEN 0 THEN 'sedan'
            WHEN 1 THEN 'limousine'
            WHEN 2 THEN 'hatchback'
            WHEN 3 THEN 'universal'
            WHEN 4 THEN 'coupe'
            WHEN 5 THEN 'convertible'
            WHEN 6 THEN 'cabriolet'
            WHEN 7 THEN 'roadster'
            WHEN 8 THEN 'targa'
            WHEN 9 THEN 'minivan'
            WHEN 10 THEN 'liftback'
            WHEN 11 THEN 'pickup'
            WHEN 12 THEN 'truck'
            WHEN 13 THEN 'crossover'
            WHEN 14 THEN 'other'
           END)::car_body_type,
        (CASE floor(random() * 3)::INT
            WHEN 0 THEN 'automatic'
            WHEN 1 THEN 'mechanical'
            WHEN 2 THEN 'robotic'
            WHEN 3 THEN 'variator'
            END)::transmission_type,
        (CASE floor(random() * 2)::INT
            WHEN 0 THEN 'front-wheel'
            WHEN 1 THEN 'rear-wheel'
            WHEN 2 THEN 'all-wheel'
            END)::wheel_drive_type,
        (CASE floor(random())::INT
            WHEN 0 THEN 'left'
            WHEN 1 THEN 'right'
            END)::rudder
FROM generate_series(1, 100000)
ON CONFLICT (car_num) DO NOTHING;



-- Создание записей фоток
DO $$ 
DECLARE 
    car_num_value text;
BEGIN
    FOR car_num_value IN (SELECT car_num FROM cars) LOOP
        FOR i IN 1..(floor(random() * 2) + 1) LOOP
            INSERT INTO photos(car_num, link, date, added_by)
            VALUES (
                car_num_value,
                'https://ru.imgbb.com/' || car_num_value || floor(random() * 100000)::int,
                NOW(),
                floor(random() * 99999 + 1)::int
            );
        END LOOP;
    END LOOP;
END $$;

INSERT INTO insurance(car_num, company, type, amount, price, start_date, end_date) 
SELECT car_num, 
		(CASE floor(random() * 7)::INT
            WHEN 0 THEN 'Alex inc'
            WHEN 1 THEN 'LOL insurance'
            WHEN 2 THEN 'KEK KASKO'
            WHEN 3 THEN 'OOO SAGO'
            WHEN 4 THEN 'OOO SWAGO'
            WHEN 5 THEN 'KASKA'
            WHEN 6 THEN 'MMM'
           END),
       (CASE floor(random() * 3)::INT
            WHEN 0 THEN 'КАСКО + ОСАГО'
            WHEN 1 THEN 'КАСКО'
            WHEN 2 THEN 'ОСАГО'
           END),
        (floor(random() * 100)::int * 1000000),
        (floor(random() * 100)::int * 10000), 
        NOW() - (floor(random()*365)::int || ' days')::interval,
        NOW() + (floor(random()*365)::int || ' days')::interval
FROM (SELECT car_num FROM cars);



INSERT INTO crashes(car_num, date, description) 
SELECT car_num, NOW() - (floor(random()*700)::int || ' days')::interval, CASE floor(random() * 6)::INT
            WHEN 0 THEN 'Легкий урон: Мелкие царапины, сколы краски, незначительные повреждения, которые не затрагивают работоспособность автомобиля.'
            WHEN 1 THEN 'Средний урон: Повреждения, которые могут затруднить работу автомобиля, но не приводят к его непригодности для движения. Например, повреждения кузова или фар.'
            WHEN 2 THEN 'Серьезный урон: Повреждения, из-за которых автомобиль становится непригодным для движения и требует ремонта. Это могут быть серьезные деформации кузова или механические повреждения, такие как поломка двигателя.'
            WHEN 3 THEN 'Катастрофический урон: Аварии, после которых автомобиль считается полностью утраченным и не подлежит восстановлению.'
            WHEN 4 THEN 'Без урона: Случаи, когда автомобиль остается абсолютно целым и без повреждений.'
            WHEN 5 THEN NULL
           END
FROM (
    SELECT car_num, ROW_NUMBER() OVER (ORDER BY car_num) AS rownum
    FROM cars
) AS numbered_cars
WHERE (rownum % 100) = 0;

