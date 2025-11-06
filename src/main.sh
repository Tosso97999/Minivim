#!/bin/bash
# MINIVIM - Mini ambiente de desenvolvimento leve em Bash

# Diretório de trabalho padrão
WORKDIR="$HOME/minivim_workspace"
mkdir -p "$WORKDIR"

# Cores para visual
verde="\e[32m"
azul="\e[34m"
amarelo="\e[33m"
vermelho="\e[31m"
reset="\e[0m"

# Função principal
menu() {
  clear
  echo -e "${azul}=== MINIVIM - Ambiente leve de desenvolvimento ===${reset}"
  echo -e "Diretório atual: ${amarelo}$WORKDIR${reset}"
  echo ""
  echo "1) Criar novo arquivo"
  echo "2) Abrir arquivo existente"
  echo "3) Executar arquivo .sh"
  echo "4) Listar arquivos"
  echo "5) Mudar diretório de trabalho"
  echo "6) Sair"
  echo ""
  read -p "Escolha: " opcao

  case $opcao in
    1) criar_arquivo ;;
    2) abrir_arquivo ;;
    3) executar_script ;;
    4) listar ;;
    5) mudar_diretorio ;;
    6) sair ;;
    *) echo -e "${vermelho}Opção inválida!${reset}"; sleep 1; menu ;;
  esac
}

criar_arquivo() {
  read -p "Nome do novo arquivo: " nome
  arquivo="$WORKDIR/$nome"
  echo "#!/bin/bash" > "$arquivo"
  chmod +x "$arquivo"
  echo -e "${verde}Arquivo criado: $arquivo${reset}"
  sleep 1
  editar_arquivo "$arquivo"
}

abrir_arquivo() {
  listar
  read -p "Nome do arquivo para abrir: " nome
  arquivo="$WORKDIR/$nome"
  if [[ -f "$arquivo" ]]; then
    editar_arquivo "$arquivo"
  else
    echo -e "${vermelho}Arquivo não encontrado.${reset}"
    sleep 1
  fi
  menu
}

editar_arquivo() {
  arquivo="$1"
  while true; do
    clear
    echo -e "${azul}=== Editando: $arquivo ===${reset}"
    echo "Conteúdo atual:"
    echo -e "${amarelo}"
    nl -ba "$arquivo"
    echo -e "${reset}"
    echo "Comandos: [a] adicionar linha | [d] deletar linha | [s] salvar e sair | [q] sair sem salvar"
    read -p ">> " cmd
    case $cmd in
      a)
        read -p "Digite o texto: " texto
        echo "$texto" >> "$arquivo"
        ;;
      d)
        read -p "Número da linha para apagar: " linha
        sed -i "${linha}d" "$arquivo"
        ;;
      s)
        echo -e "${verde}Arquivo salvo!${reset}"
        sleep 1
        break
        ;;
      q)
        echo -e "${amarelo}Saindo sem salvar...${reset}"
        sleep 1
        break
        ;;
      *)
        echo "Comando inválido"; sleep 1 ;;
    esac
  done
  menu
}

executar_script() {
  listar
  read -p "Nome do script para executar: " nome
  arquivo="$WORKDIR/$nome"
  if [[ -x "$arquivo" ]]; then
    echo -e "${azul}=== Saída do script ===${reset}"
    bash "$arquivo"
  else
    echo -e "${vermelho}Arquivo não é executável ou não existe.${reset}"
  fi
  read -p "Pressione ENTER para voltar..."
  menu
}

listar() {
  echo -e "${verde}Arquivos em $WORKDIR:${reset}"
  ls -1 "$WORKDIR"
  echo ""
}

mudar_diretorio() {
  read -p "Novo diretório de trabalho: " novo
  mkdir -p "$novo"
  WORKDIR="$novo"
  echo -e "${verde}Diretório alterado para: $WORKDIR${reset}"
  sleep 1
  menu
}

sair() {
  echo -e "${amarelo}Saindo do Minivim...${reset}"
  sleep 1
  clear
  exit
}

menu
