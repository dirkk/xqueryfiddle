angular.module('ace', []).directive('ace', function() {
  function loadAceEditor(element, mode, ro) {
    var editor = ace.edit(element[0]);
    editor.setTheme("ace/theme/textmate");
    editor.getSession().setMode("ace/mode/" + mode);
    if (ro !== 'undefined' && ro == 'true')
      editor.setReadOnly(true);

    return editor;
  }

  return {
    restrict: 'A',
    require: '?ngModel',
    transclude: true,
    template: '<div class="transcluded" ng-transclude></div><div class="ace_editor"></div>',

    link: function(scope, element, attrs, ngModel) {
      if (!ngModel) return; // do nothing if no ngModel

      var mode = attrs.ace;
      var readonly = attrs.aceReadonly+'';
      var editor = loadAceEditor(element, mode, readonly);

      ngModel.$render = function() {
        var value = ngModel.$viewValue || '';
        editor.getSession().setValue(value);
      };

      editor.getSession().on('change', function() {
        ngModel.$setViewValue(editor.getSession().getValue());
      });

      var value = ngModel.$viewValue || '';
      editor.getSession().setValue(value);
    }
  }
});
