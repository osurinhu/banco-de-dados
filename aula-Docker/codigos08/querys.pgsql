CREATE TABLE fornecedor(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    site VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE produtos(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    preco NUMERIC(12,2),
    estoque INTEGER DEFAULT 0,
    id_fornecedor INTEGER NOT NULL,
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id)
);

CREATE TABLE clientes(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cidade VARCHAR(150),
    data_nascimento DATE
);

CREATE TABLE Pedidos(
    id SERIAL PRIMARY KEY,
    data_pedido DATE DEFAULT CURRENT_DATE,
    id_cliente INTEGER,
    valor_total NUMERIC(12,2),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido(
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quntidade INTEGER NOT NULL,
    preco_unitario NUMERIC(12,2) NOT NULL,
    CONSTRAINT pk_itens_pedido PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT pk_item_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    CONSTRAINT pk_item_pedido_produto FOREIGN KEY (id_produto) REFERENCES produtos(id)
);