package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.ui.FlxInputText; // Necesitas esto para el campo de texto
import flixel.util.FlxColor;

class WinLoginState extends FlxState
{
    var fondoBoyfriend:FlxSprite;
    var fotoPerfil:FlxSprite;
    var nombreUsuario:FlxText;
    var campoContrasena:FlxInputText;
    
    override public function create():Void
    {
        super.create();
        
        // 1. El fondo de Boyfriend (Simulando la carpeta "inicio/iniciar")
        fondoBoyfriend = new FlxSprite(0, 0).loadGraphic(Paths.image('windows10/iniciar'));
        fondoBoyfriend.setGraphicSize(FlxG.width, FlxG.height);
        fondoBoyfriend.updateHitbox();
        add(fondoBoyfriend);
        
        // 2. Foto de perfil de Boyfriend
        fotoPerfil = new FlxSprite(0, 0).loadGraphic(Paths.image('windows10/perfil'));
        fotoPerfil.screenCenter();
        fotoPerfil.y -= 100; // Subirla un poco
        add(fotoPerfil);
        
        // 3. Nombre de usuario
        nombreUsuario = new FlxText(0, fotoPerfil.y + fotoPerfil.height + 20, FlxG.width, "Boyfriend");
        nombreUsuario.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        add(nombreUsuario);
        
        // 4. El "coso" de la contraseña (Input Text)
        // Posicionado debajo del nombre
        campoContrasena = new FlxInputText(0, nombreUsuario.y + 60, 300, "", 24, FlxColor.BLACK, FlxColor.WHITE);
        campoContrasena.screenCenter(X);
        campoContrasena.passwordMode = true; // Para que muestre puntitos de contraseña
        campoContrasena.focus(); // Activa el teclado automáticamente
        add(campoContrasena);
        
        // Texto de ayuda temporal
        var info:FlxText = new FlxText(0, FlxG.height - 40, FlxG.width, "Presiona ENTER para iniciar sesión");
        info.setFormat(null, 16, FlxColor.WHITE, CENTER);
        add(info);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        // Detectar si el usuario presiona ENTER
        if (FlxG.keys.justPressed.ENTER)
        {
            verificarContrasena();
        }
    }
    
    function verificarContrasena():Void
    {
        // Comprobamos si escribió "gf"
        if (campoContrasena.text.toLowerCase() == "gf")
        {
            // Contraseña correcta -> Sonido y directo al MainMenuState
            FlxG.sound.play(Paths.sound('confirmMenu')); // O el de Windows si lo agregas
            
            MusicBeatState.switchState(new MainMenuState());
        }
        else
        {
            // Contraseña incorrecta -> Limpiar campo para reintentar
            campoContrasena.text = "";
            FlxG.camera.shake(0.01, 0.2); // Un pequeño temblor de error estilo Windows
        }
    }
}