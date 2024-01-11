function detectCircularReferences(root) {
  let nodes = []
  function detectCircularReferencesInternal(path, node) {
    if (!node) {
      return
    }

    for (let n of nodes) {
      if (Object.is(node, n)) {
        console.log(
          `[Circular Reference] path = '${path}', node = `,
          node
        );
        return;
      }
    }
    nodes.push(node)
    if (node instanceof Array) {
      for (let key in node) {
        let subPath = `${path}[${key}]`;
        let child = node[key];
        detectCircularReferencesInternal(subPath, child);
      }
    } else {
      for (let key of Object.keys(node)) {
        let subPath = `${path}.${key}`;
        let child = node[key];
        detectCircularReferencesInternal(subPath, child);
      }
    }
    nodes.pop()
  }
  detectCircularReferencesInternal('', root)
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

function test_detectCircularReferences() {
  detectCircularReferences(test_getRoot());
}