SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mecanica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mecanica` DEFAULT CHARACTER SET utf8 ;
USE `mecanica` ;

-- -----------------------------------------------------
-- Table `mecanica`.`Material`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Material` (
  `idMaterial` INT NOT NULL AUTO_INCREMENT,
  `Nome da Peça` VARCHAR(45) NOT NULL,
  `Quantidade Disponivel` INT NOT NULL,
  `Valor Unitário` FLOAT NOT NULL,
  PRIMARY KEY (`idMaterial`));


-- -----------------------------------------------------
-- Table `mecanica`.`Pessoa Jurídica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Pessoa Jurídica` (
  `idPJ` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `Telefone` CHAR(11) NOT NULL,
  `E-mail` VARCHAR(45) NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Estado` CHAR(25) NOT NULL,
  PRIMARY KEY (`idPJ`));


-- -----------------------------------------------------
-- Table `mecanica`.`Pessoa Física`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Pessoa Física` (
  `idPF` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `Data de Nascimento` DATE NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Estado` CHAR(25) NOT NULL,
  `Telefone` CHAR(11) NOT NULL,
  `E-mail` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPF`));


-- -----------------------------------------------------
-- Table `mecanica`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `idClientePF` INT NULL DEFAULT -1,
  `idClientePJ` INT NULL DEFAULT -1,
  PRIMARY KEY (`idCliente`),
  INDEX `fk_Cliente_Cliente PJ1_idx` (`idClientePJ` ASC) VISIBLE,
  INDEX `fk_Cliente_Cliente PF1_idx` (`idClientePF` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Cliente PJ1`
    FOREIGN KEY (`idClientePJ`)
    REFERENCES `mecanica`.`Pessoa Jurídica` (`idPJ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cliente_Cliente PF1`
    FOREIGN KEY (`idClientePF`)
    REFERENCES `mecanica`.`Pessoa Física` (`idPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mecanica`.`Veiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Veiculo` (
  `idVeiculo` INT NOT NULL AUTO_INCREMENT,
  `idCliente` INT NOT NULL,
  `Tipo de Veiculo` ENUM('Moto', 'Carro', 'Caminhão') NOT NULL DEFAULT 'Carro',
  `Placa` CHAR(7) NOT NULL,
  `Marca` VARCHAR(45) NOT NULL,
  `Modelo` VARCHAR(45) NOT NULL,
  `Detalhe` VARCHAR(45) NULL,
  `Cor` VARCHAR(45) NOT NULL,
  `Ano` CHAR(4) NOT NULL,
  PRIMARY KEY (`idVeiculo`, `idCliente`),
  INDEX `fk_Veiculo_Cliente1_idx` (`idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Veiculo_Cliente1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `mecanica`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mecanica`.`Ordem de Serviço`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Ordem de Serviço` (
  `idOS` INT NOT NULL AUTO_INCREMENT,
  `idVeiculo` INT NOT NULL,
  `idCliente` INT NOT NULL,
  `Status_ordem` ENUM('Em Análise', 'Em execução', 'Concluida', 'Recusada') NOT NULL DEFAULT 'Em Análise',
  `Data Emissão` DATE NOT NULL,
  `Previsão` DATE NOT NULL,
  `Valor Total` FLOAT NULL,
  PRIMARY KEY (`idOS`, `idVeiculo`, `idCliente`),
  INDEX `fk_Ordem de Serviço_Veiculo1_idx` (`idVeiculo` ASC, `idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Ordem de Serviço_Veiculo1`
    FOREIGN KEY (`idVeiculo` , `idCliente`)
    REFERENCES `mecanica`.`Veiculo` (`idVeiculo` , `idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mecanica`.`Funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Funcionario` (
  `idFuncionario` INT NOT NULL AUTO_INCREMENT,
  `Matrícula` VARCHAR(10) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cargo` VARCHAR(45) NOT NULL,
  `Especialidade` VARCHAR(45) NOT NULL,
  `Data de Contratação` DATE NOT NULL,
  `Salário` FLOAT NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `Data de Nascimento` DATE NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `CEP` CHAR(8) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Estado` CHAR(2) NOT NULL,
  `Telefone` CHAR(11) NOT NULL,
  PRIMARY KEY (`idFuncionario`, `Matrícula`));


-- -----------------------------------------------------
-- Table `mecanica`.`Mão de Obra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Mão de Obra` (
  `idServiço` INT NOT NULL AUTO_INCREMENT,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor Hora` FLOAT NOT NULL,
  PRIMARY KEY (`idServiço`));


-- -----------------------------------------------------
-- Table `mecanica`.`Requer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Requer` (
  `Ordem de Serviço_idOS` INT NOT NULL,
  `Material_idMaterial` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 1,
  `Valor Aplicado` FLOAT NOT NULL,
  PRIMARY KEY (`Ordem de Serviço_idOS`, `Material_idMaterial`),
  INDEX `fk_Ordem de Serviço_has_Material_Material1_idx` (`Material_idMaterial` ASC) VISIBLE,
  INDEX `fk_Ordem de Serviço_has_Material_Ordem de Serviço1_idx` (`Ordem de Serviço_idOS` ASC) VISIBLE,
  CONSTRAINT `fk_Ordem de Serviço_has_Material_Ordem de Serviço1`
    FOREIGN KEY (`Ordem de Serviço_idOS`)
    REFERENCES `mecanica`.`Ordem de Serviço` (`idOS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ordem de Serviço_has_Material_Material1`
    FOREIGN KEY (`Material_idMaterial`)
    REFERENCES `mecanica`.`Material` (`idMaterial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mecanica`.`Consome`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Consome` (
  `Ordem de Serviço_idOS` INT NOT NULL,
  `Mão de Obra_idServiço` INT NOT NULL,
  `Horas Consideradas` FLOAT NOT NULL,
  `Valor Hora Aplicado` FLOAT NOT NULL,
  PRIMARY KEY (`Ordem de Serviço_idOS`, `Mão de Obra_idServiço`),
  INDEX `fk_Ordem de Serviço_has_Mão de Obra_Mão de Obra1_idx` (`Mão de Obra_idServiço` ASC) VISIBLE,
  INDEX `fk_Ordem de Serviço_has_Mão de Obra_Ordem de Serviço1_idx` (`Ordem de Serviço_idOS` ASC) VISIBLE,
  CONSTRAINT `fk_Ordem de Serviço_has_Mão de Obra_Ordem de Serviço1`
    FOREIGN KEY (`Ordem de Serviço_idOS`)
    REFERENCES `mecanica`.`Ordem de Serviço` (`idOS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ordem de Serviço_has_Mão de Obra_Mão de Obra1`
    FOREIGN KEY (`Mão de Obra_idServiço`)
    REFERENCES `mecanica`.`Mão de Obra` (`idServiço`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mecanica`.`Cliente Aprova Execução`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mecanica`.`Cliente Aprova Execução` (
  `Ordem de Serviço_idOS` INT NOT NULL,
  `Ordem de Serviço_idVeiculo` INT NOT NULL,
  `Ordem de Serviço_idCliente` INT NOT NULL,
  `Funcionario_idFuncionario` INT NOT NULL,
  `Aprovação` TINYINT NOT NULL DEFAULT 0,
  `Conclusão` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Ordem de Serviço_idOS`, `Ordem de Serviço_idVeiculo`, `Ordem de Serviço_idCliente`, `Funcionario_idFuncionario`),
  INDEX `fk_Ordem de Serviço_has_Funcionario_Funcionario1_idx` (`Funcionario_idFuncionario` ASC) VISIBLE,
  INDEX `fk_Ordem de Serviço_has_Funcionario_Ordem de Serviço1_idx` (`Ordem de Serviço_idOS` ASC, `Ordem de Serviço_idVeiculo` ASC, `Ordem de Serviço_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Ordem de Serviço_has_Funcionario_Ordem de Serviço1`
    FOREIGN KEY (`Ordem de Serviço_idOS` , `Ordem de Serviço_idVeiculo` , `Ordem de Serviço_idCliente`)
    REFERENCES `mecanica`.`Ordem de Serviço` (`idOS` , `idVeiculo` , `idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ordem de Serviço_has_Funcionario_Funcionario1`
    FOREIGN KEY (`Funcionario_idFuncionario`)
    REFERENCES `mecanica`.`Funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
