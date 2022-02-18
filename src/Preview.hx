import haxe.Exception;
import js.Browser;
import haxe.ui.HaxeUIApp;
import haxe.ui.RuntimeComponentBuilder;

extern class VsCodeApi {
    public static inline function acquireVsCodeApi():VsCodeApi return js.Syntax.code('acquireVsCodeApi()');
    public function postMessage(any:Dynamic):Void;
}

class Preview {
    public static function main() {
        var app = new HaxeUIApp();
        var vsCodeApi = VsCodeApi.acquireVsCodeApi();
        inline function postMessage(data:VsData) {
			vsCodeApi.postMessage(data);
		}
        haxe.Log.trace = (v:Dynamic, ?infos:haxe.PosInfos) -> {
            postMessage({
                type: warning,
                message: Std.string(v),
            });
        };
        var component = null;
        app.ready(app.start);
        Browser.window.addEventListener('message', event -> {
            var data:PreviewData = event.data;
            var xml = data.xml;
            try {
                var newComponent = RuntimeComponentBuilder.fromString(xml, 'xml');
                if(component != null) app.removeComponent(component);
                app.addComponent(newComponent);
                component = newComponent;
            } catch(e:Exception) {
                postMessage({
                    type: error,
                    message: e.toString(),
                });
            }
        });
    }
    
}