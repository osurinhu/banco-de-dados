-- Ativa foreign keys no inicio do script
PRAGMA foreign_keys = NO;

-- Tabela usuario
CREATE TABLE usuario(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL,
    senha TEXT NOT NULL
);

-- Tabela cliente
CREATE TABLE cliente(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    telefone TEXT,
    usuario_id INTEGER NOT NULL UNIQUE,

    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE 
);

-- Tabela produto
CREATE TABLE produto(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    preco REAL NOT NULL CHECK (preco >= 0)
);

-- Tabela venda
CREATE TABLE venda(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    usuario_id INTEGER NOT NULL UNIQUE,
    cliente_id INTEGER NOT NULL UNIQUE,

    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE SET NULL
);

-- Tabela venda_produto tabela associativa oara N:M produto <-> venda
CREATE TABLE venda_produto(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    venda_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario REAL NOT NULL CHECK (preco_unitario >= 0),

    FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE,
    FOREIGN KEY (venda_id) REFERENCES venda(id) ON DELETE CASCADE
);

-- Inserir Usuario
-- SEMPRE CIFRE SENHAS!!!
INSERT INTO usuario(nome, email, senha) VALUES ('Antonio', 'antonim@unipam.edu.br', 'oinotna');
INSERT INTO usuario(nome, email, senha) VALUES ('osuru', 'osuru@unipam.edu.br', 'uruos');
INSERT INTO usuario(nome, email, senha) VALUES ('kuji', 'kuji@unipam.edu.br', 'ijuk');
INSERT INTO usuario(nome, email, senha) VALUES ('games', 'games@unipam.edu.br', 'semag');

-- Inseir Clientes
INSERT INTO cliente(nome, telefone, usuario_id)
VALUES 
    ('antom', '999999999', 1),
    ('osur', '999998888', 2),
    ('kujii', '999997777', 3),
    ('game', '999996666', 4);

-- Inserir Produto
-- SQLite não recomenda uso do tipo REAL para moedas 
INSERT INTO produto(nome, descricao, preco)
VALUES
    ('Arroz 5kg', 'Arroz tipo 1', 10.20),
    ('Feijao 1kg', 'Feijao carioca', 7.25),
    ('Acucar', 'Acucar refinado', 5.35);

-- Inserir Venda
INSERT INTO venda(data, usuario_id, cliente_id)
VALUES
    ('2025-08-27', 1, 1),
    ('2025-08-27', 2, 2),
    ('2025-08-27', 3, 3);

-- Inserir dados na tabela de associação venda
INSERT INTO venda_produto(venda_id, produto_id, quantidade, preco_unitario)
VALUES
    (1,1,3,10.20),
    (1,2,5,7.25),
    (2,2,1,7.25),
    (2,3,2,5.25),
    (3,1,2,10.20);