package options;
import options.Option;

class VSliceSubState extends BaseOptionsMenu {
    public function new() {
        title = "Opciones V-Slice";
        rpcTitle = "V-Slice settings menu";

		var option:Option = new Option('Contenido Vulgar',
			'Si se desactiva, se ocultará el contenido vulgar o subido de tono (como insultos, groserías, etc.)',
			'vsliceNaughtyness',
			BOOL);
		addOption(option);

		var option:Option = new Option('Pantalla de Resultados',
			'Si se desactiva, no se mostrará la pantalla de resultados al terminar una canción.',
			'vsliceResults',
			BOOL);
		addOption(option);

		var option:Option = new Option('Barra de Vida Fluida',
			'Si se activa, hace que la barra de salud se mueva de forma mucho más suave.',
			'vsliceSmoothBar',
			BOOL,);
		addOption(option);

		var option:Option = new Option('Usar Barra Clásica',
			'Hace que la barra de salud y el texto de puntuación sean mucho más simples.',
			'vsliceLegacyBar',
			BOOL,);
		addOption(option);
		var option:Option = new Option('Tarjetas Especiales de Freeplay',
			'Si se desactiva, obligará a todos los personajes a usar la tarjeta de BF (incluyendo a Pico).',
			'vsliceSpecialCards',
			BOOL);
		addOption(option);
        super();
    }
}