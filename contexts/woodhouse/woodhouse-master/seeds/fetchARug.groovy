job('fetch-a-rug') {
  description('This is for those in the know to amuse themselves.')
  parameters {
    stringParam('WHAT_TO_FETCH', 'a rug', 'What I shall do!')
  }
  steps {
    shell('echo "I shall fetch a ${WHAT_TO_FETCH}, sir!"')
  }
}
