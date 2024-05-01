# **Instalação do Terraform**

### **macOS**

1. **Instale o Homebrew**  
   Abra o Terminal e execute o seguinte comando para instalar o Homebrew, se ainda não estiver instalado:
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Instale o Terraform**  
   Com o Homebrew instalado, você pode facilmente instalar o Terraform executando:
   ```
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   ```

3. **Verifique a instalação**  
   Para garantir que o Terraform foi instalado corretamente, execute:
   ```
   terraform -version
   ```
   Isso deve mostrar a versão do Terraform instalada.

---

### **Linux**

1. **Baixe o pacote**  
   Acesse o [site oficial do Terraform](https://developer.hashicorp.com/terraform/install) e baixe o pacote apropriado para a sua distribuição Linux.

2. **Descompacte o arquivo**  
   Extraia o arquivo baixado em uma pasta que faz parte do seu PATH. Você pode usar:
   ```
   unzip terraform_1.1.0_linux_amd64.zip -d /usr/local/bin/
   ```
   Substitua `terraform_1.1.0_linux_amd64.zip` pelo nome do arquivo que você baixou.

3. **Verifique a instalação**  
   Verifique se o Terraform foi instalado corretamente:
   ```
   terraform -version
   ```
   A saída deve exibir a versão do Terraform.

---

### **Windows**

1. **Baixe o Terraform**  
   Visite o [site oficial do Terraform](https://developer.hashicorp.com/terraform/install) e baixe o arquivo apropriado para Windows.

2. **Extraia o arquivo**  
   Após o download, extraia os arquivos para uma pasta que está incluída no PATH do sistema, como `C:\Terraform`.

3. **Adicione o Terraform ao PATH**  
   - Abra o Painel de Controle > Sistema e Segurança > Sistema > Configurações Avançadas do Sistema.
   - Clique em Variáveis de Ambiente e edite a variável `Path` para incluir o caminho onde você extraiu o Terraform.

4. **Verifique a instalação**  
   Abra o Prompt de Comando e digite:
   ```
   terraform -version
   ```
   A saída deve confirmar a versão do Terraform instalada.
