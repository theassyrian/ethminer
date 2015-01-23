import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0

Item {

	property string currentDocumentId: ""

	function getDocumentText(documentId) {
		for (i = 0; i < editorListModel.count; i++)	{
			if (editorListModel.get(i).documentId === documentId) {
				return editors.itemAt(i).getText();
			}
		}
		return "";
	}

	function openDocument(document)	{
		loadDocument(document);
		currentDocumentId = document.documentId;
	}

	function loadDocument(document) {
		for (var i = 0; i < editorListModel.count; i++)
			if (editorListModel.get(i).documentId === document.documentId)
				return; //already open

		editorListModel.append(document);
	}

	function doLoadDocument(editor, document) {
		var data = fileIo.readFile(document.path);
		if (document.isContract)
			editor.onEditorTextChanged.connect(function() {
				codeModel.registerCodeChange(editor.getText());
			});
		editor.setText(data, document.syntaxMode);
	}

	Connections {
		target: projectModel
		onDocumentOpened: {
			openDocument(document);
		}
		onProjectSaving: {
			for (var i = 0; i < editorListModel.count; i++)
				fileIo.writeFile(editorListModel.get(i).path, editors.itemAt(i).item.getText());
		}
		onProjectClosed: {
			for (var i = 0; i < editorListModel.count; i++)	{
				editors.itemAt(i).visible = false;
			}
			editorListModel.clear();
			currentDocumentId = "";
		}
	}

	CodeEditor {
		id: codeEditor
	}

	Repeater {
		id: editors
		model: editorListModel
		delegate: Loader {
			active: false;
			asynchronous: true
			anchors.fill:  parent
			sourceComponent: codeEditor
			visible: (index >= 0 && index < editorListModel.count && currentDocumentId === editorListModel.get(index).documentId)
			onVisibleChanged: {
				loadIfNotLoaded()
			}
			Component.onCompleted: {
				loadIfNotLoaded()
			}
			onLoaded: { doLoadDocument(item, editorListModel.get(index)) }

			function loadIfNotLoaded () {
				if(visible && !active) {
					active = true;
				}
			}
		}
	}
	ListModel {
		id: editorListModel
	}
}
