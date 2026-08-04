package options;
import options.Option;

class PSliceSubState extends BaseOptionsMenu {
    public function new() {
        title = "Configuración S-v2";
        rpcTitle = "P-Slice settings menu";
        var option:Option = new Option('Color dinámico en Freeplay',
			'Activa el color de fondo dinámico en el menú Freeplay. Desactívalo si prefieres los colores originales de V-Slice.',
			'vsliceFreeplayColors',
			BOOL);
		addOption(option);
		
		#if sys
		var option:Option = new Option('Tipo de Registro (Log)',
			'Controla qué tantos detalles y eventos guarda el juego en sus registros técnicos.',
			'loggingType',
			STRING,["Ninguno","Consola","Archivo"]);
		addOption(option);
		#end
		var option:Option = new Option('Forzar etiqueta "Nuevo"',
			'Si se activa, obligará a que cada canción no completada muestre la etiqueta "nuevo" aunque esté desactivada.',
			'vsliceForceNewTag',
			BOOL);
		addOption(option);

		#if MULTITHREADED_LOADING
		var option:Option = new Option('Caché Multi-hilo', //Name
		"Si se marca, activa la carga multi-hilo, lo que mejora los tiempos de carga pero con un riesgo bajo de congelar el juego al cargar.", //Description
		'cacheOnCPU',
		BOOL);
		addOption(option);
		#end

		#if STRICT_LOADING_SCREEN
		var option:Option = new Option('Pantalla de Carga Estricta', //Name
		"Si se marca, el juego descargará primero los elementos de la interfaz antes de precargar la canción (útil para dispositivos de poca memoria).", //Description
		'strictLoadingScreen',
		BOOL);
		addOption(option);
		#end

        super();
    }
}