# extract-certificate
# 🛠️ Script de Extração de Certificado `.pfx` para Apache HTTPD

Este documento descreve como usar um script shell para extrair certificado, chave privada e cadeia de certificação de um arquivo `.pfx`, preparando tudo para uso com o Apache HTTPD.

---

## ✅ Como usar o script de extração de certificado `.pfx`

### 1. Salve o script

Crie um arquivo chamado `extrair-cert.sh` e cole o conteúdo do script nele.

### 2. Dê permissão de execução

```bash
chmod +x extrair-cert.sh
```

### 3. Execute o script

```bash
./extrair-cert.sh caminho/para/seu_certificado.pfx
```

> O script solicitará a senha do arquivo `.pfx`.

---

## 📂 Arquivos Gerados

O script criará um diretório chamado `cert-nome_do_arquivo` contendo:

| Arquivo               | Descrição                                  |
|-----------------------|--------------------------------------------|
| `chave.key`           | Chave privada **sem senha**                |
| `certificado.crt`     | Certificado público extraído               |
| `ca-bundle.crt`       | Cadeia de certificação (intermediários/raiz) |
| `key-com-protecao.key`| (opcional) Versão protegida da chave privada |

> Os arquivos terão permissões seguras:
> - `.key` → `600`
> - `.crt` → `644`

---

## 🔧 Exemplo de uso no Apache HTTPD

```apache
<VirtualHost *:443>
    ServerName www.seudominio.com

    SSLEngine on
    SSLCertificateFile /caminho/para/certificado.crt
    SSLCertificateKeyFile /caminho/para/chave.key
    SSLCertificateChainFile /caminho/para/ca-bundle.crt

    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
</VirtualHost>
```

> Lembre-se de reiniciar o Apache após as alterações:

```bash
sudo systemctl restart apache2  # ou `httpd` em CentOS/RHEL
```

