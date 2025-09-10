-- Questão 1: Normalização para 1NF

-- Criando a tabela original (não normalizada)
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Solução em 1NF: criar uma nova tabela já normalizada
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Inserindo os dados em 1NF (cada produto em uma linha)
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Laptop');
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Tablet');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Keyboard');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (103, 'Emily Clark', 'Phone');

-- Agora cada linha representa apenas 1 produto, eliminando repetição na mesma célula.
-- Questão 2: Normalização para 2NF

-- Criando tabela original (em 1NF mas com dependência parcial)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Normalização para 2NF: separação em duas tabelas

-- Tabela de pedidos (cada cliente aparece 1 vez por pedido)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Tabela de itens (ligada pelo OrderID)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems VALUES (101, 'Laptop', 2);
INSERT INTO OrderItems VALUES (101, 'Mouse', 1);
INSERT INTO OrderItems VALUES (102, 'Tablet', 3);
INSERT INTO OrderItems VALUES (102, 'Keyboard', 1);
INSERT INTO OrderItems VALUES (102, 'Mouse', 2);
INSERT INTO OrderItems VALUES (103, 'Phone', 1);

-- Agora CustomerName depende totalmente de OrderID,
-- e OrderItems depende da chave OrderID + Product. ✅
-- Questão 3: Normalização para 3NF

-- Passo 1: Criar tabela de Produtos independente
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    UnitPrice DECIMAL(10,2) -- Exemplo: guardar preço
);

-- Inserir os produtos sem repetição
INSERT INTO Products (ProductName, UnitPrice) VALUES
('Laptop', 1200.00),
('Mouse', 25.00),
('Tablet', 500.00),
('Keyboard', 45.00),
('Phone', 700.00);

-- Passo 2: Alterar a tabela OrderItems para usar ProductID em vez de texto
CREATE TABLE OrderItems_3NF (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inserir os dados normalizados (relacionando via ProductID)
INSERT INTO OrderItems_3NF VALUES (101, 1, 2); -- John Doe, Laptop
INSERT INTO OrderItems_3NF VALUES (101, 2, 1); -- John Doe, Mouse
INSERT INTO OrderItems_3NF VALUES (102, 3, 3); -- Jane Smith, Tablet
INSERT INTO OrderItems_3NF VALUES (102, 4, 1); -- Jane Smith, Keyboard
INSERT INTO OrderItems_3NF VALUES (102, 2, 2); -- Jane Smith, Mouse
INSERT INTO OrderItems_3NF VALUES (103, 5, 1); -- Emily Clark, Phone

-- Agora:
-- Orders  -> guarda apenas informações do pedido e cliente
-- Products -> guarda informações únicas de cada produto
-- OrderItems_3NF -> conecta pedidos e produtos com suas quantidades
