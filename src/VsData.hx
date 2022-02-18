enum abstract VsDataType(String) {
    var error;
    var warning;
}

typedef VsData = {
    var type:VsDataType;
    var message:String;
}