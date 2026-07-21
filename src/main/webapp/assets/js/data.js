// ==================== BASE DE DATOS DE DESTINOS (ESCALABLE) ====================
// Cada destino tiene ID único global. Puedes agregar más sin problemas
// Sugerencia: usa IDs del 100 en adelante para nuevos destinos

const destinosData = [
    // ========== COSTA (IDs: 1-99) ==========
    { 
        id: 1, 
        nombre: "Paracas - Reserva Nacional", 
        region: "costa", 
        imagen: "img/Paracas.jpg",
        precioBase: 180, 
        descripcion: "Ballenas, islas Ballestas y dunas para sandboard",
        duracionMinima: 2,
        incluye: ["Transporte", "Hospedaje 3*", "Tour Islas Ballestas"],
        popularidad: 5
    },
    { 
        id: 2, 
        nombre: "Máncora - Playa & Surf", 
        region: "costa", 
        imagen: "https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=600",
        precioBase: 220, 
        descripcion: "Sol todo el año, surf y vida nocturna",
        duracionMinima: 2,
        incluye: ["Transporte", "Hospedaje frente al mar", "Clase de surf"],
        popularidad: 4
    },
    // NUEVOS DESTINOS DE COSTA
    // { 
    //     id: 3, 
    //     nombre: "Punta Sal - Playa Escondida", 
    //     region: "costa", 
    //     imagen: "IMAGEN",
    //     precioBase: 250, 
    //     descripcion: "Aguas turquesas y tranquilidad absoluta",
    //     duracionMinima: 2,
    //     incluye: ["Transporte", "Hospedaje boutique", "Kayak"],
    //     popularidad: 4
    // },
    
    // ========== SIERRA (IDs: 100-199) ==========
    { 
        id: 100, 
        nombre: "Cusco - Machu Picchu", 
        region: "sierra", 
        imagen: "img/machupicchu.jpeg",
        precioBase: 350, 
        descripcion: "La capital imperial y maravilla del mundo",
        duracionMinima: 3,
        incluye: ["Transporte", "Hospedaje 4*", "Entrada Machu Picchu", "Guía profesional"],
        popularidad: 5
    },
    { 
        id: 101, 
        nombre: "Arequipa - Valle del Colca", 
        region: "sierra", 
        imagen: "img/Colca.jpg",
        precioBase: 270, 
        descripcion: "Volcanes, cóndores y arquitectura sillar",
        duracionMinima: 2,
        incluye: ["Transporte", "Hospedaje 3*", "Tour Valle del Colca"],
        popularidad: 4
    },
    // NUEVOS DESTINOS DE SIERRA (puedes agregar más aquí con IDs 102, 103, etc.)
    // { 
    //     id: 102, 
    //     nombre: "Huaraz - Laguna 69", 
    //     region: "sierra", 
    //     imagen: "URL_IMAGEN",
    //     precioBase: 200, 
    //     descripcion: "Senderismo y montañas nevadas",
    //     duracionMinima: 3,
    //     incluye: ["Transporte", "Hospedaje", "Guía de montaña"],
    //     popularidad: 4
    // },
    
    // ========== SELVA (IDs: 200-299) ==========
    { 
        id: 200, 
        nombre: "Iquitos - Río Amazonas", 
        region: "selva", 
        imagen: "img/Iquitos_Amazonas.jpg",
        precioBase: 290, 
        descripcion: "La puerta a la Amazonía peruana",
        duracionMinima: 3,
        incluye: ["Transporte fluvial", "Lodge amazónico", "Excursiones nocturnas"],
        popularidad: 5
    },
    { 
        id: 201, 
        nombre: "Tarapoto - Cataratas", 
        region: "selva", 
        imagen: "img/tarapoto_catarata.jpg",
        precioBase: 210, 
        descripcion: "Cascadas, lagunas y aventuras",
        duracionMinima: 2,
        incluye: ["Transporte", "Hospedaje", "Tour cataratas"],
        popularidad: 4
    },
    // NUEVOS DESTINOS DE SELVA (puedes agregar más aquí con IDs 202, 203, etc.)
    // { 
    //     id: 202, 
    //     nombre: "Puerto Maldonado - Reserva Tambopata", 
    //     region: "selva", 
    //     imagen: "URL_IMAGEN",
    //     precioBase: 320, 
    //     descripcion: "Lobos de río y biodiversidad extrema",
    //     duracionMinima: 3,
    //     incluye: ["Transporte", "Lodge ecológico", "Excursiones guiadas"],
    //     popularidad: 4
    // }
];

// ==================== FUNCIONES PARA MANEJAR DESTINOS ====================

// Obtener destinos por región
// Filtra y retorna los destinos que pertenecen a una región específica
// Usa el método filter() del arreglo
function getDestinosByRegion(region) {
    return destinosData.filter(d => d.region === region);
}

// Obtener destino por ID
function getDestinoById(id) {
    return destinosData.find(d => d.id === parseInt(id));   // parseInt() convierte el parámetro a número porque el value del select es string
}

// Obtener todos los destinos
function getAllDestinos() {
    return destinosData;
}

// Obtener destinos destacados (los más populares)
function getDestinosDestacados(limite = 3) {
    return [...destinosData].sort((a, b) => b.popularidad - a.popularidad).slice(0, limite);
}   // sort() ordena el arreglo, slice() toma los primeros 'limite' elementos

// Constante de impuesto (IGV 18%)
const IGV_PORCENTAJE = 0.18;
// Calcular precio con impuestos
function calcularPrecioConImpuestos(subtotal) {
    const igv = subtotal * IGV_PORCENTAJE;
    const total = subtotal + igv;
    return { subtotal, igv, total };
}

// Equipo de asesores
const teamData = [
    { nombre: "María Flores", cargo: "Especialista Costa", img: "https://randomuser.me/api/portraits/women/68.jpg" },
    { nombre: "Carlos Quispe", cargo: "Experto Sierra", img: "https://randomuser.me/api/portraits/men/32.jpg" },
    { nombre: "Lucía Rengifo", cargo: "Amazonía y Eco", img: "https://randomuser.me/api/portraits/women/45.jpg" },
    { nombre: "Diego Huamán", cargo: "Reservas & Logística", img: "https://randomuser.me/api/portraits/men/52.jpg" }
];