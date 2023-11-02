CREATE TABLE city (
    id SERIAL PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    age INT,
    CHECK (age >= 0)
);

CREATE TABLE laboratory (
    id SERIAL PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    abbreviation VARCHAR (32) NOT NULL,
    employees INT,
    CHECK (employees > 0 OR employees IS NULL)
);

CREATE TABLE scientist (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    degree VARCHAR(255) NOT NULL,
    lab_id INT,
    city_id INT,
    FOREIGN KEY (lab_id) REFERENCES laboratory(id),
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE block (
    id SERIAL PRIMARY KEY,
    age INT,
    find_date DATE,
    scientist_id INT,
    city_id INT,
    FOREIGN KEY (scientist_id) REFERENCES scientist(id),
    FOREIGN KEY (city_id) REFERENCES city(id),
    CHECK (age >= 0)
);

CREATE TABLE rock (
    id SERIAL PRIMARY KEY,
    material VARCHAR (255) NOT NULL,
    block_id INT,
    FOREIGN KEY (block_id) REFERENCES block(id)
);

