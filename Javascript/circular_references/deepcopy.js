function deepCopyWithoutCircularReference(root) {
  let nodes = [];
  function deepCopyWithoutCircularReferenceInternal(node) {
    if (!node) {
      return null;
    }
    for (let n of nodes) {
      if (Object.is(node, n)) {
        return null;
      }
    }
    nodes.push(node);
    if (node instanceof Array) {
      let result = [];
      for (let key in node) {
        result.push(deepCopyWithoutCircularReferenceInternal(node[key]));
      }
      return result;
    } else {
      let result = {};
      for (let key of Object.keys(node)) {
        result[key] = deepCopyWithoutCircularReferenceInternal(node[key]);
      }
      return result;
    }
    nodes.pop();
  }
  return deepCopyWithoutCircularReferenceInternal(root);
}

function test_getRoot() {
  let root = {};
  let child1 = { parent: root };
  let child2 = { parent: child1 };
  let child3 = { children: [child1, child2] };
  root.child1 = child1;
  root.child2 = child2;
  root.child3 = child3;
  return root;
}


function test_deepCopyWithoutCircularReference() {
  console.log(deepCopyWithoutCircularReference(test_getRoot()))
}
