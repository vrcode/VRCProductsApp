CREATE TABLE products (
  product_id INTEGER NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
  product_name TEXT NOT NULL,
  product_description TEXT DEFAULT "",
  product_regular_price NUMBER DEFAULT 0,
  product_sale_price NUMBER DEFAULT 0,
  product_photo BLOB DEFAULT NULL,
  product_colors TEXT DEFAULT "",
  product_stores TEXT DEFAULT "{}"
);
