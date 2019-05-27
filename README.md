# Processador Risk V

## Sumário:
* [Descrição dos módulos](./#-[:link:](https://github.com/Pulho/Processador-Risc-V/blob/master/etc/Circuito.png)-Descrição-dos-módulos)
* [Descrição das Operações](./#-Descrição-das-operações)
* [Descrição dos estados de Controle](./#-[:link:](https://github.com/Pulho/Processador-Risc-V/blob/master/etc/maquinaDeEstados.png)-Descrição-dos-Estados-de-Controle)

## [:link:](https://github.com/Pulho/Processador-Risc-V/blob/master/etc/Circuito.png) Descrição dos módulos
### Módulo: UnidadeControle

**Entradas:**
* clk (1 bit): clock do sistema.
* reset (1 bit): caso o reset esteja em nível lógico alto, zera todas as saídas mandando para o estado início da Unidade Controle.
* Instr (32 bits): Instrução completa.
* OPcode (7 bits): 7 bits que representam o código da instrução.
* func7 (7 bits): 7 bits que fazem parte da instrução, usados para diferenciação em grupos de instruções semelhantes.
* func3 (3 bits): 3 bits que fazem parte da instrução, usados para diferenciação em grupos de instruções semelhantes.

**Saída:**
* stateout (5 bits): Variável de controle para saber o estado em que a máquina de estados se encontra.
* Shift (3 bits): Variável de controle para os shifts, especificando qual será selecionado de acordo com os 3 bits do shift.
* Wrl (1 bit): Flag que autoriza ou não a escrita na memória de instrução.
* Wrd (1 bit): Flag que autoriza ou não a escrita na memória de dados.
* RegWrite (1 bit): Flag que autoriza ou não a escrita no banco de registradores.
* LoadIR (1 bit): Flag que autoriza ou não a leitura de instruções no  Registrador de instrução.
* MemToReg (3 bit): Variável de controle de seleção do muxEspecial - Vai selecionar a saída do mux conforme a entrada de bits * dessa variável.
* ALUSrcA (2 bits): Variável de controle para seleção do mux_A - Vai selecionar a saída do mux conforme a entrada de bits dessa variável.
* ALUSrcB (2 bits): Variável de controle para seleção do mux_B - Vai selecionar a saída do mux conforme a entrada de bits dessa variável.
* ALUFct (3 bits): Variável de controle da operação da ULA.
* PCWrite (1 bit): Flag que autoriza ou não a escrita no PC.
* PCWriteCondbeq (1 bit): Flag que autoriza ou não a escrita no PC, criado para o caso específico do BEQ.
* PCWriteCondbne (1 bit) :Flag que autoriza ou não a escrita no PC, criado para o caso específico do BNE .
* PCWriteCondbge (1 bit): Flag que autoriza ou não a escrita no PC, criado para o caso específico do BGE.
* PCWriteCondblt (1 bit): Flag que autoriza ou não a escrita no PC, criado para o caso específico do BLT.
* PCSource (1 bit): Flag de controle para seleção do mux_ALUOut- Vai selecionar a saída do mux conforme a entrada de bits dessa variável.
* LoadRegA (1 bit): Flag que autoriza ou não o carregamento no registrador A da saída vinda do banco de registradores.
* LoadRegB (1 bit): Flag que autoriza ou não o carregamento no registrador B da saída vinda do banco de registradores.
* LoadAOut (1 bit): Flag que autoriza ou não o carregamento no registrador da saída da ALU.
* LoadMDR (1 bit): Flag que autoriza ou não o carregamento no registrador de dados de memória.
* flagCausa (1 bit): Flag que autoriza a escrita no EPC e no registrador de causa.
* causa (1 bit): Sinal a ser escrito no registrador de causa, dependendo do tipo de exceção.
* muxInstr (1 bit): Flag para selecionar qual endereço vai passar para a memória de instruções, o que vem de PC ou o endereço 254 se houver uma exceção.

**Objetivo:** 
Como o nome mesmo diz, é uma unidade que vai controlar o que o módulo principal (datapath) precisa fazer para determinada instrução.

**Algoritmo:**
Usamos da máquina de estados que fizemos, e disponibilizamos, para setar cada saída necessária da unidade de controle em determinados estados. Assim, o datapath só faz o que é preciso para a instrução que está sendo executada no momento.
Como temos disponíveis como entrada Instr, OPcode, func3 e func7, podemos diferenciar as instruções e seguir os estados que mandam os sinais corretos para o módulo principal realizar as operações que determinada instrução pede.

### Módulo: muxEspecial

**Entradas:**
* sinalMenor (1 bit): Flag de comparação, fica em alto quando o registrador A é menor que o B.
* sel (3 bits): Sinal que vem da unidade de controle, para selecionar a entrada correta.
* e1 (64 bits): Sinal que vem do registrador da saída da ALU.
* e2 (64 bits): Sinal que vem do registrador de dados de memória.
* e3 (64 bits): Sinal que vem do Extensor de sinal.
* e4 (64 bits): Sinal que vem do módulo de deslocamento que é usado para operações de shift.
* e5 (64 bits): Sinal que vem de PC, é usado na operação de jal.
* inst (32 bits): Instrução completa.

**Saída:**
* f (64 bits): Sinal de ativação do mux, relativo à operação selecionada.

**Objetivo:**
Criado para, além de emitir um sinal de ativação, tratar as saídas a serem salvas nos registradores referentes a algumas operações específicas.

**Algoritmo:**
Além da seleção, trata separadamente as instruções de load e a slti. No caso dos loads, estende o sinal para completar os 64 bits, caso necessário. Para o slti, apenas armazena o valor 0 ou 1 ( em 64 bits) no registrador.  

### Módulo: ExtendSg

**Entradas:**
* menorSinal (1 bit):
* in (32 bits):

**Saída:**
* out (64 bits):

**Objetivo:**
Pegar a entrada de 32 bits, arrumar e estender para 64bits.

**Algoritmo:**
A entrada de 32 bits é na verdade a instrução completa que vem do módulo de registrador de instruções, dependendo da instrução ocorre um tratamento e o sinal também é estendido para 64 bits.

### Módulo: Store

**Entradas:**
* func3 (3 bits):3 bits que fazem parte da instrução, usados para diferenciação em grupos de instruções semelhantes.
* regLD (64 bits): Registrador de contenção, usado para preservar os bits não modificados caso necessário.
* regBase (64 bits): Registrador que contém o valor a ser armazenado antes do tratamento.

**Saída:**
* regWR (64 bits): Registrador que contém o valor a ser armazenado.

**Objetivo:**
Criado para resolução das instruções de store abrangendo os casos de doubleword, word, halfword e byte.

**Algoritmo:**
Faz seleção do store por meio do func3, redirecionando para a instrução correspondente. Dependendo da instrução selecionada o algoritmo armazena na memória uma word, halfword, doubleword ou byte.

--------------------------------------------------------------------------------------------------------------------------------

## Descrição das operações

### TIPO R

**Instrução add rd, rs1, rs2:**
Após a identificação da instrução na etapa de decodificação, o registrador destino recebe o resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle),  entre os registradores fonte 1 e 2, que têm seus valores carregados a partir do banco de registradores.

**Instrução sub rd, rs1, rs2:**
Após a identificação da instrução na etapa de decodificação, o registrador destino recebe o resultado da subtração aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre os registradores fonte 1 e 2, que têm seus valores carregados a partir do banco de registradores.

**Instrução and rd, rs1, rs2:**
Após a identificação da instrução na etapa de decodificação, o registrador destino recebe o resultado da operação AND bit a bit, vindo da ALU (ativada por sinais vindos da unidade de controle),  entre os registradores fonte 1 e 2, que têm seus valores carregados a partir do banco de registradores.

**Instrução slt rd, rs1, rs2:**
Após a identificação da instrução na etapa de decodificação, o registrador destino recebe 1 (em 64 bits), caso a ALU (ativada por sinais vindos da unidade de controle) determine que o valor do registrador fonte 1 é menor que o valor do registrador fonte 2, e 0 (em 64 bits), caso contrário. Os registradores fonte tem seus valores carregados a partir do banco de registradores.

### TIPO I

**Instrução addi rd, rs, imm:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle),  entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato).

**Instrução slti sd, rs1, imm:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá 1 (em 64 bits), caso a ALU (ativada por sinais vindos da unidade de controle) determine que o valor do registrador fonte (carregado a partir do banco de registradores) é menor que o valor da constante (imediato), e 0 (em 64 bits), caso contrário.

**Instrução jalr rd, rs1, imm:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor atual do contador de programas (PC) e o PC receberá o resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato).

**Instrução ld rd, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor guardado na posição de memória (carregado a partir da memória de dados) representada pelo resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato).
	
**Instrução lw rd, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá, em seus primeiros 32 bits, o valor guardado na posição de memória (carregado a partir da memória de dados) representada pelo resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato), tendo seu sinal estendido para completar os 64 bits totais.

**Instrução lbu rd, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá, em seus primeiros 8 bits, o valor guardado na posição de memória (carregado a partir da memória de dados) representada pelo resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato), tendo seu sinal estendido para completar os 64 bits totais.

**Instrução lh rd, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá, em seus primeiros 16 bits, o valor guardado na posição de memória (carregado a partir da memória de dados) representada pelo resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o valor do registrador fonte (carregado a partir do banco de registradores) e a constante dada (imediato), tendo seu sinal estendido para completar os 64 bits totais.

**Instrução nop:**
Representa a falta de instruções a serem executadas.

**Instrução break:**
Representa a parada de execução.

### TIPO I ( Shifts )

**Instrução srli rd, rs1, shamt:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor do registrador fonte (carregado a partir do banco de registradores) após a execução de “x” shifts lógicos à direita, executados por um módulo específico de shift, onde “x” representa o valor constante referente ao campo “shamt” da instrução.

**Instrução srai rd, rs1, shamt:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor do registrador fonte (carregado a partir do banco de registradores) após a execução de “x” shifts lógicos à direita, executados por um módulo específico de shift, onde “x” representa o valor constante referente ao campo “shamt” da instrução. O registrador destino tem seu sinal estendido, por um módulo de extensão específico, ao fim da operação.

**Instrução slli rd, rs1, shamt:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor do registrador fonte (carregado a partir do banco de registradores) após a execução de “x” shifts lógicos à esquerda, executados por um módulo específico de shift, onde “x” representa o valor constante referente ao campo “shamt” da instrução.

### TIPO S

**Instrução sd rs2, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, a posição de memória representada pela soma aritmética, vinda da ALU (ativada por sinais vindos da unidade de controle), entre o valor do  registrador fonte 1 e a constante dada (imediato) receberá o valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

**Instrução sw rs2, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, a posição de memória representada pela soma aritmética, vinda da ALU (ativada por sinais vindos da unidade de controle), entre o valor do  registrador fonte 1 e a constante dada (imediato) receberá os primeiros 32 bits do valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

**Instrução sh rs2, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, a posição de memória representada pela soma aritmética, vinda da ALU (ativada por sinais vindos da unidade de controle), entre o valor do  registrador fonte 1 e a constante dada (imediato) receberá os primeiros 16 bits do valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.
 
**Instrução sb rs2, imm(rs1):**
Após a identificação da instrução na etapa de decodificação, a posição de memória representada pela soma aritmética, vinda da ALU (ativada por sinais vindos da unidade de controle), entre o valor do  registrador fonte 1 e a constante dada (imediato) receberá os primeiros 8 bits do valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

### TIPO SB

**Instrução beq rs1, rs2, imm:**
Após a identificação da instrução na etapa de decodificação, o contador de programas (PC) será deslocado de acordo com a constante dada (imediato), que representa a quantidade de meias instruções, caso a ALU (ativada por sinais vindos da unidade de controle) determine que os valores dos registradores fonte 1 e 2 são iguais. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

**Instrução bne rs1, rs2, imm:**
Após a identificação da instrução na etapa de decodificação, o contador de programas (PC) será deslocado de acordo com a constante dada (imediato), que representa a quantidade de meias instruções, caso a ALU (ativada por sinais vindos da unidade de controle) determine que os valores dos registradores fonte 1 e 2 são diferentes. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

**Instrução bge rs1, rs2, imm:**
Após a identificação da instrução na etapa de decodificação, o contador de programas (PC) será deslocado de acordo com a constante dada (imediato), que representa a quantidade de meias instruções, caso a ALU (ativada por sinais vindos da unidade de controle) determine que o valor do registrador fonte 1 é maior ou igual ao valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

**Instrução blt rs1, rs2, imm:**
Após a identificação da instrução na etapa de decodificação, o contador de programas (PC) será deslocado de acordo com a constante dada (imediato), que representa a quantidade de meias instruções, caso a ALU (ativada por sinais vindos da unidade de controle) determine que o valor do registrador fonte 1 é menor que o valor do registrador fonte 2. Os valores dos registradores fonte 1 e 2 são carregados a partir do banco de registradores.

### TIPO U

**Instrução lui rd, imm:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá, entre os bits 31 e 12, o valor da constante dada (imediato).

### TIPO UJ

**Instrução jal rd, imm:**
Após a identificação da instrução na etapa de decodificação, o registrador destino receberá o valor atual do contador de programas (PC) e o PC receberá o resultado da soma aritmética, vindo da ALU (ativada por sinais vindos da unidade de controle), entre o antigo valor de PC e a constante dada (imediato).

--------------------------------------------------------------------------------------------------------------------------------

## [:link:](https://github.com/Pulho/Processador-Risc-V/blob/master/etc/maquinaDeEstados.png) Descrição dos Estados de Controle

**Estado: inicio**
Nesse estado são zerados todas as variáveis e flags de controle da Unidade de Controle e define o próximo estado para o BInst (Busca de instrução )*

**Estado: BInst (Busca de instrução)**
Nesse estado é feita a busca de instrução e define o próximo estado para o IDecod (Decodificação de Instrução)*

**Estado: IDecod (Decodificação de Instrução)**
Nesse estado é feita a decodificação de instrução, analisando o OPcode, func7 e func3 para determinar qual será o próximo estágio. Também trata do caso específico da instrução nop.*

**Estado: Cem (Cálculo de endereçamento da memória)**
Nesse estado é feito o cálculo de endereçamento da memória, assim como a análise do OPcode para diferenciar se é uma instrução de Store, Load ou um Addi, definindo, assim, qual será o próximo estado.

**Estado: Amld (Acesso de memória leitura)**
Nesse estado são zeradas todas as variáveis e flags de controle da Unidade de Controle e ,em seguida, é analisado o OPCode para diferenciar de operações de Store e operações de Load. Assim, a próxima instrução depende do OPCode.

**Estado: Amsd (Acesso de memória escrita)**
Nesse estado ativa-se a flag WrD para a escrita na memória de dados. Esse estado é utilizado exclusivamente para operações de Store. Define inicio como próximo estado.

**Estado: Ev (Escrevendo de volta)**
Nesse estado é feita a escrita no banco de registradores com o valor carregado da memória de dados. Define inicio como próximo estado.

**Estado: Exeadd (Execução da op Add)**
Nesse estado é feito o uso da ALUFct para denotar a operação de adição da ALU e a ativação da flag LoadAOut para permitir o carregamento do resultado pós- operação. As entradas referentes aos registradores fonte da operação selecionada são definidas por ALUSrcA e ALUSrcB. Define Cr como próximo estado.

**Estado: Exesub (Execução da op Sub)**
Nesse estado é feito o uso da ALUFct para denotar a operação de subtração da ALU e a ativação da flag LoadAOut para permitir o carregamento do resultado pós- operação. As entradas referentes aos registradores fonte da operação selecionada são definidas por ALUSrcA e ALUSrcB. Define Cr como próximo estado.

**Estado: Exeand (Execução da op And)**
Nesse estado é feito o uso da ALUFct para denotar a operação de AND bit a bit da ALU e a ativação da flag LoadAOut para permitir o carregamento do resultado pós- operação. As entradas referentes aos registradores fonte da operação selecionada são definidas por ALUSrcA e ALUSrcB. Define Cr como próximo estado.

**Estado: Exeslt (Execução da op Slt)**
Nesse estado é feito o uso da ALUFct para denotar a operação de comparação da ALU e a ativação da regWrite para permitir que seja escrito no registrador o resultado de acordo com a comparação da ALU.

**Estado: Exeslti (Execução da op Slti)**
Nesse estado é feito o uso da ALUFct para denotar a operação de subtração da ALU e a ativação da flag LoadAOut para permitir o carregamento do resultado pós- operação. As entradas referentes aos registradores fonte da operação selecionada são definidas por ALUSrcA e ALUSrcB. Define inicio como próximo estado.

**Estado: Cr (Conclusão do tipo R + Addi)**
Nesse estado é feito a escrita no banco de registradores dos resultados das operações do tipo R e do Addi pela ativação da flag RegWrite. Define inicio como próximo estado.

**Estado: Lui (Execução da op Lui)**
Nesse estado é feito o carregamento do imediato com o registrador destino. Em seguida, é ativa-se a flag do RegWrite para armazenar o novo valor do registrador no banco de registradores. Define inicio como próximo estado.

**Estado: Crcjal (Conclusão do ramo condicional Jal)**
Aqui é carregado no registrador destino o endereço atual de PC, e também é carregado no PC o endereço para onde é especificado na instrução, endereço este que já foi calculado. Define inicio como próximo estado.

**Estado: DecodJalR**
Aqui é calculado o endereço para onde irá retornar, endereço este que foi guardado no registrador fonte 1, e será guardado no registrador da saída da ALU. Define Crcjalr como próximo estado.

**Estado: Crcjalr (Conclusão do ramo condicional Jalr)**
Aqui é passado o endereço, que já foi calculado e está guardado no registrador da saída da ALU, para o PC. Define inicio como próximo estado.

**Estado: Srli**
Nesse estado é feito o uso do shift para denotar a operação do shift lógico à direita. Define inicio como próximo estado.

**Estado: Srai**
Nesse estado é feito o uso do shift para denotar a operação do shift aritmético à direita. Define inicio como próximo estado.

**Estado: Slli**
Nesse estado é feito o uso do shift para denotar a operação do shift lógico à esquerda. Define inicio como próximo estado.

**Estado: Crcbeq (Conclusão do ramo condicional Beq)**
Aqui é feita a comparação entre os dois registradores, se a saída zero da ALU for 1, o endereço determinado pela instrução, que já foi calculado pela ALU, é carregado no PC. Se for 0, PC fica com PC + 4. Define inicio como próximo estado.
	
**Estado: Crcbne (Conclusão do ramo condicional Bne)**
Aqui é feita a comparação entre os dois registradores, se a saída zero da ALU for 0, o endereço determinado pela instrução, que já foi calculado pela ALU, é carregado no PC. Se for 1, PC fica com PC + 4. Define inicio como próximo estado.

**Estado: Crcbge (Conclusão do ramo condicional Bge)**
Aqui é feita a comparação entre os dois registradores, se as saídas maior ou igual da ALU forem 1, o endereço determinado pela instrução, que já foi calculado pela ALU, é carregado no PC. Se ambos forem 0, PC fica com PC + 4. Define inicio como próximo estado.

**Estado: Crcblt (Conclusão do ramo condicional Blt)**
Aqui é feita a comparação entre os dois registradores, se a saída menor da ALU for 1, o endereço determinado pela instrução, que já foi calculado pela ALU, é carregado no PC. Se for 0, PC fica com PC + 4. Define inicio como próximo estado.

**Estado: exc**
Nesse estado, PC é subtraído por 4, para EPC poder pegar o endereço da instrução na qual gerou a exceção no próximo estado. E é carregado o endereço 254 na memória de instruções para poder pegar 100 que ainda será tratado. Define exc2 como próximo estado.

**Estado: exc2**
Aqui é ativo a flagCausa para EPC pegar o endereço exato da instrução que gerou a exceção e o registrador de causa pegar o valor 1 ou 0, dependendo da exceção. Define exc3 como próximo estado.

**Estado: exc3**
Depois de o valor 100 ter o sinal estendido, é passado para PC. Define Break como próximo estado.

**Estado: Break**
Nesse estado é formado um loop, ou seja, define-se Break como seu próximo estado.

--------------------------------------------------------------------------------------------------------------------------------
## Desenvolvedores
* [João Victor de Lima Peixoto](https://github.com/jvlp) 

* [Manoel Alves Xavier Neto](https://github.com/maxn13)

* [Paulo Victor de Oliveira Andrade](https://github.com/Pulho)

* [Paulo Vinícius Fernandes de Lima Silva](https://github.com/pvfls)

