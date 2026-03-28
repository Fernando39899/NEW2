# ==========================================
# SISTEMA INTELIGENTE DE RUTAS (A*)
# ==========================================

import heapq

# ==========================================
# BASE DE CONOCIMIENTO (REGLAS)
# ==========================================
# Representación: nodo -> [(vecino, costo)]

GRAFO = {
    "Portal": [("Centro", 10), ("Sur", 5)],
    "Centro": [("Norte", 8), ("Terminal", 7)],
    "Sur": [("Centro", 3), ("Terminal", 12)],
    "Norte": [("Terminal", 2)],
    "Terminal": []
}

# ==========================================
# HEURÍSTICA (estimación al destino)
# Valores estimados (pueden representar distancia)
# ==========================================

HEURISTICA = {
    "Portal": 15,
    "Centro": 10,
    "Sur": 12,
    "Norte": 2,
    "Terminal": 0
}

# ==========================================
# FUNCIÓN: ALGORITMO A*
# ==========================================

def a_estrella(grafo, heuristica, inicio, objetivo):
    """
    Implementación del algoritmo A*
    Retorna:
        - ruta óptima
        - costo total
    """

    # Cola de prioridad
    frontera = []
    heapq.heappush(frontera, (0, inicio))

    # Costos acumulados
    costo_acumulado = {inicio: 0}

    # Para reconstruir el camino
    padres = {inicio: None}

    while frontera:
        prioridad_actual, nodo_actual = heapq.heappop(frontera)

        # Si llegamos al objetivo, terminamos
        if nodo_actual == objetivo:
            break

        # Explorar vecinos
        for vecino, costo in grafo[nodo_actual]:
            nuevo_costo = costo_acumulado[nodo_actual] + costo

            # Si encontramos mejor camino
            if vecino not in costo_acumulado or nuevo_costo < costo_acumulado[vecino]:
                costo_acumulado[vecino] = nuevo_costo

                prioridad = nuevo_costo + heuristica[vecino]
                heapq.heappush(frontera, (prioridad, vecino))

                padres[vecino] = nodo_actual

    # Reconstrucción del camino
    ruta = reconstruir_ruta(padres, inicio, objetivo)

    return ruta, costo_acumulado.get(objetivo, float("inf"))

# ==========================================
# FUNCIÓN: RECONSTRUIR RUTA
# ==========================================

def reconstruir_ruta(padres, inicio, objetivo):
    ruta = []
    nodo = objetivo

    while nodo is not None:
        ruta.append(nodo)
        nodo = padres.get(nodo)

    ruta.reverse()

    # Validar si realmente llegó al inicio
    if ruta[0] == inicio:
        return ruta
    else:
        return []

# ==========================================
# FUNCIÓN: MOSTRAR GRAFO
# ==========================================

def mostrar_grafo(grafo):
    print("\n--- RED DE TRANSPORTE ---")
    for nodo in grafo:
        print(f"{nodo} -> {grafo[nodo]}")

# ==========================================
# FUNCIÓN PRINCIPAL
# ==========================================

def main():
    print("===================================")
    print(" SISTEMA INTELIGENTE DE RUTAS (A*) ")
    print("===================================")

    mostrar_grafo(GRAFO)

    while True:
        print("\nIngrese los puntos (o escriba 'salir')")

        inicio = input("Punto de inicio: ").strip()
        if inicio.lower() == "salir":
            break

        destino = input("Destino: ").strip()
        if destino.lower() == "salir":
            break

        # Validación
        if inicio not in GRAFO:
            print("❌ Error: Nodo de inicio no válido")
            continue

        if destino not in GRAFO:
            print("❌ Error: Nodo destino no válido")
            continue

        # Ejecutar algoritmo
        ruta, costo = a_estrella(GRAFO, HEURISTICA, inicio, destino)

        # Mostrar resultados
        if ruta:
            print("\n✅ Mejor ruta encontrada:")
            print(" → ".join(ruta))
            print(f"Costo total: {costo}")
        else:
            print("⚠️ No se encontró ruta")

# ==========================================
# EJECUCIÓN
# ==========================================

if __name__ == "__main__":
    main()
