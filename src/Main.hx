import vscode.*;

class Main {
    @:expose('activate')
	static function activate(context:ExtensionContext) {
		var currentPanel:WebviewPanel = null;
		var currentDoc:TextDocument = null;
		inline function postMessage(data:PreviewData) {
			currentPanel.webview.postMessage(data);
		}
		inline function isValid(document:TextDocument) {
			return document.languageId == 'xml';
		}
		
		context.subscriptions.push(Vscode.commands.registerCommand('haxeui.preview', () -> {
			currentDoc = Vscode.window.activeTextEditor.document;
			if(isValid(currentDoc)) {
				if(currentPanel == null) {
					currentPanel = Vscode.window.createWebviewPanel(
						'haxeui.preview',
						'Haxeui Preview',
						{
							viewColumn:vscode.ViewColumn.Two,
							preserveFocus:true,
						},
						{
							enableScripts: true,
						}
					);

					currentPanel.onDidDispose(event -> {
						currentPanel = null;
					});
		
					currentPanel.webview.html = getWebViewContent();
					currentPanel.webview.onDidReceiveMessage(message -> {
						var data:VsData = message;
						switch data.type {
							case error: Vscode.window.showErrorMessage(data.message);
							case warning: Vscode.window.showWarningMessage(data.message);
						}
					});
				} else {
					currentPanel.reveal(vscode.ViewColumn.Two);
				}
				postMessage({
					xml: currentDoc.getText()
				});
			}
		}));
		
		Vscode.workspace.onDidSaveTextDocument(document -> {
			if(document.fileName == currentDoc.fileName) {
				postMessage({
					xml: document.getText()
				});
			}
		});
	}

	static inline function getWebViewContent() {
		return CompilerFile.getContent('head.html') + '<body><script>' + CompilerFile.getContent('build/preview.js') + '</script></body>';
	}
}
