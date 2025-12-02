PRAGMA foreign_keys = ON;

CREATE TABLE participante (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    telefone TEXT NOT NULL
);

CREATE TABLE evento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    local TEXT NOT NULL,
    data TEXT NOT NULL
);

CREATE TABLE inscricao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_evento INTEGER NOT NULL,
    id_participante INTEGER NOT NULL,
    data_inscricao TEXT,
    status TEXT,

    FOREIGN KEY (id_evento) REFERENCES evento(id) ON DELETE CASCADE,
    FOREIGN KEY (id_participante) REFERENCES participante(id) ON DELETE CASCADE
);

CREATE TABLE pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_inscricao INTEGER UNIQUE,
    valor REAL CHECK( valor >= 0),
    data_pagamento TEXT,
    status TEXT,

    FOREIGN KEY (id_inscricao) REFERENCES inscricao(id) ON DELETE SET NULL
);


INSERT INTO participante (nome, email, telefone)
VALUES 
    ('Antonio', 'antonio@gmail.com', '999999999'),
    ('Padua', 'padua@gmail.com', '988888888'),
    ('Rabelo', 'rabelo@gmail.com', '9777777777');


INSERT INTO evento (nome, descricao, local, data)
VALUES
    ('Banco de dados legal', 'Descomplicando banco de dados', 'Unipam', '2025-11-10'),
    ('Estrutura de dados maneira', 'Explicacao de estrutra de dados', 'Unipam', '2025-10-11');


INSERT INTO inscricao ( id_evento, id_participante, data_inscricao, status)
VALUES
    (1, 1, '2025-06-21', 'confirmada'),
    (1, 2, '2025-07-02', 'confirmada'),
    (2, 1, '2025-08-11', 'confirmada'),
    (2, 3, '2025-09-05', 'confirmada');


INSERT INTO pagamento (id_inscricao, valor, data_pagamento, status)
VALUES
    (1, 10.90, '2025-06-21', 'aprovado'),
    (2, 10.90, '2025-07-03', 'aprovado'),
    (3, 15.90, '2025-08-11', 'aprovado'),
    (4, 15.90, '2025-09-05', 'pendente');
