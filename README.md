# hadoop-zulu
Imagen docker con Hadoop en modo pseudo distribuido

## Construcción de image
```
make
```

## Creación de un contenedor
```
make run hostname=<hostname>
docker run -it --rm -h "hadooptest" -p 8088:8088 -p 50070:50070 -p 50090:50090 hadoop-zulu
```

## Entrar en el contenedor
```
make attack
```

## Eliminación de un contenedor
```
make clean
```

## Eliminación de la imagen
```
make clean-image
```
