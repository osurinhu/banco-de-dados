-- criar tabelas de exemplo
CREATE TABLE IF NOT EXISTS conta (
  conta_id SERIAL PRIMARY KEY,
  titular VARCHAR(150) NOT NULL,
  saldo NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS conta_auditoria (
  audit_id SERIAL PRIMARY KEY,
  conta_id INT,
  operacao VARCHAR(10),
  antiga NUMERIC(12,2),
  nova NUMERIC(12,2),
  usuario VARCHAR(150),
  data_hora TIMESTAMPTZ DEFAULT now()
);

-- limpar e inserir dados iniciais
TRUNCATE TABLE conta RESTART IDENTITY CASCADE;
TRUNCATE TABLE conta_auditoria RESTART IDENTITY;

INSERT INTO conta(titular, saldo) VALUES
('Alice', 1000.00),
('Bruno', 500.00);

-- conferir
SELECT * FROM conta ORDER BY conta_id;


-- 1. Criar a função que será executada pela trigger
CREATE OR REPLACE FUNCTION fn_auditoria_saldo()
RETURNS TRIGGER AS $$
BEGIN
  -- Insere na tabela de auditoria os dados da operação
  INSERT INTO conta_auditoria (conta_id, operacao, antiga, nova, usuario)
  VALUES (
    NEW.conta_id,       -- ID da conta afetada
    TG_OP,              -- Operação (UPDATE)
    OLD.saldo,          -- Saldo anterior
    NEW.saldo,          -- Saldo novo
    current_user        -- Usuário do banco
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Criar a trigger associada à tabela conta
CREATE TRIGGER trg_audit_saldo
AFTER UPDATE ON conta
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_saldo()
;


BEGIN;
UPDATE conta SET saldo = saldo - 100.00 WHERE conta_id = 1;
UPDATE conta SET saldo = saldo + 100.00 WHERE conta_id = 2;
COMMIT;

-- Verificar o saldo atualizado
SELECT conta_id, titular, saldo FROM conta ORDER BY conta_id;


-- Verificar se a trigger gravou o histórico
SELECT * FROM conta_auditoria ORDER BY audit_id;


BEGIN;
-- Tentativa de transação com valores errados
UPDATE conta SET saldo = saldo - 100000.00 WHERE conta_id = 1;
UPDATE conta SET saldo = saldo + 100000.00 WHERE conta_id = 2;

-- Verificamos que algo está errado e damos rollback
ROLLBACK;

-- Verificar que os saldos voltaram ao normal
SELECT conta_id, titular, saldo FROM conta ORDER BY conta_id;

-- Verificar que a auditoria também foi revertida (não há registros dessa tentativa falha)
SELECT * FROM conta_auditoria WHERE nova > 10000;

BEGIN;
UPDATE conta SET saldo = saldo - 10.00 WHERE conta_id = 1;
SAVEPOINT antes_bonus;

UPDATE conta SET saldo = saldo + 10.00 WHERE conta_id = 2;

-- desfazer apenas a segunda atualização (crédito no id 2)
ROLLBACK TO antes_bonus;

COMMIT;

SELECT conta_id, titular, saldo FROM conta ORDER BY conta_id;