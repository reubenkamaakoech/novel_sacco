document.addEventListener("turbo:load", () => {
    const clientSelect = document.getElementById("client-select");
    const branchSelect = document.getElementById("branch-select");
  
    if (clientSelect) {
      clientSelect.addEventListener("change", (event) => {
        const clientId = event.target.value;
  
        // Clear the branch dropdown
        branchSelect.innerHTML = "<option value=''>Select a branch</option>";
  
        if (clientId) {
          // Fetch branches for the selected client
          fetch(`/branches_for_client?client_id=${clientId}`)
            .then((response) => response.json())
            .then((branches) => {
              branches.forEach((branch) => {
                const option = document.createElement("option");
                option.value = branch.id;
                option.textContent = branch.name;
                branchSelect.appendChild(option);
              });
            });
        }
      });
    }
  });
  