#!/bin/bash

# Crear directorio addons
mkdir -p addons
cd addons

# Descargar módulos de facturación electrónica para Ecuador
echo "Descargando módulos de facturación electrónica para Ecuador..."

# Opción 1: Repositorio OCA (Odoo Community Association)
git clone https://github.com/OCA/l10n-ecuador.git --branch 18.0 --depth 1 2>/dev/null || \
git clone https://github.com/OCA/l10n-ecuador.git --branch 17.0 --depth 1 2>/dev/null || \
git clone https://github.com/OCA/l10n-ecuador.git --branch 16.0 --depth 1

# Mover módulos a la raíz de addons
if [ -d "l10n-ecuador" ]; then
    mv l10n-ecuador/* .
    rm -rf l10n-ecuador
fi

# Opción 2: Repositorio específico para Ecuador (si existe)
git clone https://github.com/odoo-ecuador/odoo-ecuador.git --branch 18.0 --depth 1 2>/dev/null || \
git clone https://github.com/odoo-ecuador/odoo-ecuador.git --branch 17.0 --depth 1 2>/dev/null || \
echo "Repositorio odoo-ecuador no encontrado, usando solo OCA"

# Mover módulos de odoo-ecuador si existen
if [ -d "odoo-ecuador" ]; then
    mv odoo-ecuador/* .
    rm -rf odoo-ecuador
fi

# Crear archivo requirements.txt para dependencias Python
cat > requirements.txt << 'EOF'
# Dependencias específicas para facturación electrónica Ecuador SRI
cryptography==38.0.4
lxml>=4.6.0
pyOpenSSL>=21.0.0
python-dateutil>=2.8.2
requests>=2.25.1
xmltodict>=0.12.0
suds-jurko>=0.6
zeep>=4.0.0
xmlsig>=1.3.0
signxml>=2.8.0
EOF

# Crear archivo de instalación de dependencias
cat > install_dependencies.sh << 'EOF'
#!/bin/bash
# Instalar dependencias Python dentro del contenedor
docker-compose exec odoo pip install -r /mnt/extra-addons/requirements.txt
EOF

chmod +x install_dependencies.sh

echo "Módulos descargados en ./addons/"
echo "Ejecuta 'bash install_dependencies.sh' después de levantar los contenedores"
echo ""
echo "Módulos disponibles para facturación electrónica:"
ls -la | grep l10n