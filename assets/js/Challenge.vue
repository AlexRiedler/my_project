<template>
  <div>
    <div>Challenge Page</div>
    <h1>{{ challenge.title }}</h1>
    <p>{{ challenge.description }}</p>
    <div id="editor"></div>
    <div>Challenge Data: {{ challenge }}</div>
  </div>
</template>

<script>
import MonacoEditor from "monaco-editor"

export default {
  name: 'Challenge',
  components: {
  },
  data () {
    return {
      loading: false,
      challenge: null,
      error: null
    }
  },
  watch: {
    '$route': 'fetchData'
  },
  methods: {
    fetchData() {
      let challenge_id = this.$route.params.challenge_id
      let jwt_token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJteV9wcm9qZWN0IiwiZXhwIjoxNTM4MTU3ODgxLCJpYXQiOjE1MzU3Mzg2ODEsImlzcyI6Im15X3Byb2plY3QiLCJqdGkiOiIxY2QwNjQzYy1mMzhkLTQwNGQtYmQxZS0zOWMzYTkwMTcxMDgiLCJuYmYiOjE1MzU3Mzg2ODAsInN1YiI6IlVzZXI6djE6NzA2Y2Y3NGEtZWYzZi00OGQ0LTg1Y2MtNDQ3ZTMzMzI3NTAyIiwidHlwIjoiYWNjZXNzIn0.5csE4NGkyQgfi5ozVvBZ9bblfsqQ_y7DMU7ngsJoZbCjHGHEgYtatR-R8Aq2LGnVm6q2ABrmr2d89ZvbRYABzg"
      this.error = this.challenge = null
      this.loading = true
      fetch(
        `http://localhost:4000/api/v1/challenges/${challenge_id}`,
        {
          headers: {
            'Authorization': `Bearer ${jwt_token}`,
            'Content-Type': 'application/json'
          }
        }
      ).then(response => response.json()
      ).then(json => { this.challenge = json["data"]; this.loading = false }
      ).catch(error => this.error = error)
    }
  },
  mounted() {
    this.fetchData()
    MonacoEditor.create(this.$el)
  }
}
</script>

<style lang="scss">
</style>
