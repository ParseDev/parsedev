import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleInput", "toggleField"]
  toggle() {
    this.checkToggleState()
  }

  checkToggleState() {
    if (this.toggleInputTarget.checked) {
      this.toggleFieldTargets.forEach((field) => field.classList.toggle('hidden'))
    } else {
      this.toggleFieldTargets.forEach((field) => field.classList.toggle('hidden'))
    }
  }

  edit() {
    var datasourceUri = document.getElementById("datasource_uri").value;
    try {
        const connectionData = datasourceUri.replace('postgres://', '');
        

        // Split the remaining string by the '@' symbol
        const [authPart, databasePart] = connectionData.split('@');
  
        // Extract username and password
        const [username, password] = authPart.split(':');
  
        // Split the database part by '/' to get host, port, and database name
        const [hostPort, dbName] = databasePart.split('/');
  
        // Split the host and port
        const [host, port] = hostPort.split(':');
        document.getElementById('datasource_host').value = host;
        document.getElementById('datasource_port').value = port;
        document.getElementById('datasource_database_name').value = dbName;
        document.getElementById('datasource_database_username').value = username;
        document.getElementById('datasource_database_password').value = password;
    } catch (error) { 
        // 
    }
  }
}
