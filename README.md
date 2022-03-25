# Consultador de nota no Portal do Andrei

| Aluno                                    | 
| ---------------------------------------- |
| Gabriel Dutra Dias                       |
| Marcelo Lopes de Macedo Ferreira Candido |

## Descrição

Programa em bash para consultar notas do site rimsa.com.br.

## Como usar

```bash
./grader.sh -c <class> -t <semester e.g.: 2020_2> -r <student-registry>
```

Available classes: decom009 (Linguagens de Programação), decom035 (Linguages Formais e Autômatos) and decom042 (Linux)

## Tabela de conceitos utilizados

| #   | Trecho de codigo                                                                                        | Conceito                                                        | Aula                                 |
| --- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | ------------------------------------ |
| 1   | `name=$(echo "$response" \| grep '<name>' \| sed 's:[[:space:]]*<name>\(.*\)</name>:\1:')`              | Expansão de comandos via $()                                    | Expansões                            |
| 2   | `if [[ -z $name ]]; then`                                                                               | Uso do Comando if                                               | Estruturas de fluxo condicionais     |
| 3   | `for ((i = 1; i < ${#exams_arr[@]}; i++)); do`                                                          | Uso do Comando for                                              | Estruturas de repetição              |
| 4   | `sed 's:[[:space:]]*<name>\(.*\)</name>:\1:'`                                                           | Uso do comando sed na extração de valores do xml                | sed                                  |
| 5   | `echo "$response" \| grep '<name>' \| sed 's:[[:space:]]*<name>\(.*\)</name>:\1:'`                      | Uso de pipe para o processamento do texto                       | Entradas, saídas e redirecionamentos |
| 6   | `available_classes=(decom009 decom035 decom042)`                                                        | Uso de arranjos                                                 | Parâmetros e variáveis               |
| 7   | `grep '<grade id="exam'`                                                                                | Uso do grep para localizar no XML                               | Processamento de texto               |
| 8   | `sed 's:[[:space:]]*<grade id="exam.*" .*>\(.*\)</grade>:\1:'`                                          | Aplicação de regex para filtro no XML                           | Expressões regulares                 |
| 9   | `display_usage 1>&2`                                                                                    | Redirecionamento da saída padrão para a saída de erro (`1>&2`)  | Entradas, saídas e redirecionamentos |
| 10  | `IFS=$'\r\n ' name=$(echo "$response" \| grep '<name>' \| sed 's:[[:space:]]*<name>\(.*\)</name>:\1:')` | Uso da variável reservada IFS para separar os campos da entrada | Parâmetros e variáveis               |
