CREATE TABLE expenses(
    id serial PRIMARY KEY,
    amount numeric(6, 2) NOT NULL,
    memo text NOT NULL,
    created_on date default now()::date
);

ALTER TABLE expenses
    ADD CHECK (amount > 0.00);
    
INSERT INTO expenses 
    (amount, memo) 
    VALUES 
        (14.56, 'Pencils'),
        (3.29, 'Coffee'),
        (49.99, 'Text Editor'),
        (23.87, 'Bespoke Potato Carvings');
        
