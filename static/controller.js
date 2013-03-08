function EditorCtrl($scope, $http, $location, $dialog) {
  $scope.processors = [
    {
      id: "basex",
      name: "BaseX",
      execute: function(query, cb) {
        $http.defaults.headers.post['Content-Type'] = 'text/plain';
        $http({
          method: 'POST',
          url: "/restxq/execute-xquery/" + $scope.db + "/" + $scope.version,
          data: $scope.xquery
        }).
        success(function(data) {
          if (data.error) {
            $scope.alert = data.error;
            $scope.result = '';
            if (cb !== undefined && typeof cb == 'function') cb('');
          } else {
            $scope.result = data.result;
            if (cb !== undefined && typeof cb == 'function') cb(data.result);
          }
        }).
        error(function(data, status, headers, config) {
          alert("Something went wrong during query execution.");
        });
      }
    }
  ];
  if (window.location.href.lastIndexOf('#') != -1) {
    $scope.version = window.location.href.substr(window.location.href.lastIndexOf('#') + 2);
    var temp = window.location.href.substr(0, window.location.href.lastIndexOf('#'));
    $scope.db = window.location.href.substr(temp.lastIndexOf('/') + 1, 36);
    getData();
  } else {
    $scope.db = window.location.href.substr(window.location.href.lastIndexOf('/') + 1, 36);
    $http.get("/restxq/version/" + $scope.db).
    success(function(data) {
      $scope.version = data.version.toString();
      $location.path($scope.version);
      getData();
    }).
    error(function(data, status, headers, config) {
      alert("Something went wrong when deleting the document");
    });
  }

  $scope.processor = $scope.processors[0];

  function getData() {
    $http.get("/restxq/data/" + $scope.db + "/" + $scope.version).
    success(function(data) {
      $scope.docs = data.docs;
      $scope.xquery = data.config.xquery;
      if (data.config.result)
        $scope.result = data.config.result;
      else
        $scope.result = '';

      // the processor has changed, so reflect this in the application
      if (data.config.processor != $scope.processor.id) {
        angular.forEach($scope.processors, function(p) {
          if (p.id == data.config.processor)
            $scope.processor = p;
        });
      }

      if ($scope.docs.length == 0) {
        var doc = {
          title: 'doc1',
          selected: true,
          content: '<XML />'
        };
        $scope.docs.push(doc);
      }
    }).
    error(function(data, status, headers, config) {
      alert("Could not load data from server.");
    });
  }

  $scope.addDocument = function() {
    var doc = {
      title: 'doc' + ($scope.docs.length + 1),
      selected: true,
      content: '<XML />'
    };
    $scope.docs.push(doc);

    $scope.saveAll();
  }

  $scope.saveAll = function() {
    // get new version number
    $http.get("/restxq/version/new/" + $scope.db).
    success(function(data) {
      $scope.version = data.version.toString();
      $location.path($scope.version);

      $scope.putDocs = 0;
      // store documents
      $http.defaults.headers.put['Content-Type'] = 'application/xml';
      angular.forEach($scope.docs, function(doc) {
        $http({
          method: 'PUT',
          url: "/rest/" + $scope.db + "/" + $scope.version + "/" + doc.title,
          params: {chop: 'false'},
          data: doc.content
        }).
        success(function(data) {
          $scope.putDocs = $scope.putDocs + 1;

          if ($scope.putDocs >= $scope.docs.length) {
            // store query
            $http.defaults.headers.post['Content-Type'] = 'text/plain';
            $http({
              method: 'POST',
              url: "/restxq/save-xquery/" + $scope.db + "/" + $scope.version,
              data: $scope.xquery
            }).
            success(function(data) {
              if ($scope.xquery !== "undefined" && $scope.xquery != "") {
                $scope.processor.execute($scope.xquery, function(result) {
                  // store query result and processor
                  $http.defaults.headers.post['Content-Type'] = 'text/plain';
                  $http({
                    method: 'POST',
                    url: "/restxq/save-result/" + $scope.db + "/" + $scope.version + "/" + $scope.processor.id,
                    data: result
                  }).
                  success(function(data) {
                    // focus the cursor on the XQuery editor
                    ace.edit(document.getElementById('xqueryEditor')).focus();
                  }).
                  error(function(data, status, headers, config) {
                    alert("The query result could not be stored");
                  });
                  
                });
              }
            }).
            error(function(data, status, headers, config) {
              alert("Your query could not be stored.");
            });
          }
        }).
        error(function(data, status, headers, config) {
          alert("Something went wrong when updating your documents.");
        });
      });
    }).
    error(function(data, status, headers, config) {
      alert("Could not get a new version number.");
    });
  }

  $scope.run = function() {
    $scope.closeAlert();
    $scope.saveAll();
  }

  $scope.renameDocument = function(doc) {
    var d = $dialog.dialog({backdrop: true, keyboard: true, backdropClick: true});
    d.open('/renameDocument.html', 'DialogCtrl').then(function(result){
      if (result) {
        doc.title = result;
      }
    });
    $scope.saveAll();
  }

  $scope.deleteDocument = function(i) {
    $http.defaults.headers.put['Content-Type'] = 'application/xml';
      $http({
        method: 'DELETE',
        url: "/rest/" + $scope.db + "/" + $scope.docs[i].title
      }).
      success(function(data) {
        if ($scope.docs.length == 1) {
            $scope.docs.splice(0, 1);
            $scope.addDocument();
        } else {
          if (i == 0) {
            $scope.docs.splice(i, 1);
            $scope.docs[0].selected = true;
          } else {
            $scope.docs.splice(i, 1);
            $scope.docs[i].selected = true;
          }
        }

        $scope.saveAll();
      }).
      error(function(data, status, headers, config) {
        alert("Something went wrong when deleting the document");
      });
  }

  $scope.closeAlert = function() {
    $scope.alert = undefined;
  }
}

var ModalCtrl = function ($scope) {
  $scope.open = function () {
    $scope.shouldBeOpen = true;
  };

  $scope.close = function () {
    $scope.shouldBeOpen = false;
  };

  $scope.opts = {
    backdropFade: true,
    dialogFade: true
  };
};

// the dialog is injected in the specified controller
function DialogCtrl($scope, dialog) {
  $scope.close = function(result) {
    dialog.close(result);
  };
}
