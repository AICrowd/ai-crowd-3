export function showAlert(alertType, alertMessage) {
  const alertWrapper = document.getElementById('flash-messages-wrapper');

  alertWrapper.innerHTML = alertTemplate(alertType, alertMessage);
  window.scrollTo(0, 0);
}

function alertTemplate(alertType, alertMessage) {
  return `<div class="alert alert-${alertType} alert-dismissible fade show flash-message" role="alert">
            <div class="container-fluid">
              <center>${alertMessage}</center>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          </div>`;
}
