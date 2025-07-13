import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  submit(event) {
    const siteId = event.target.value;
    const employeeId = this.data.get("employee_id");
    const workDate = this.data.get("work_date");

    if (siteId === "") return;

    fetch("/attendances/quick_create", {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken(),
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        site_id: siteId,
        employee_id: employeeId,
        work_date: workDate
      })
    });
  }
}
