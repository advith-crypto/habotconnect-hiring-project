function App() {
  return (
    <main>
      <h1>HabotConnect Student Onboarding</h1>

      <p>
        Secure student onboarding interface for the HabotConnect hiring
        project.
      </p>

      <section>
        <h2>Validation</h2>
        <ul>
          <li>Deterministic Yes/No validation</li>
          <li>Django REST Framework backend</li>
          <li>Schema validation before downstream processing</li>
        </ul>
      </section>

      <section>
        <h2>Security Controls</h2>
        <ul>
          <li>Terraform Infrastructure as Code</li>
          <li>Least-privilege Identity and Access Management</li>
          <li>BigQuery Row-Level Security</li>
          <li>Fail-closed continuous integration security gate</li>
          <li>Secret scanning with Gitleaks</li>
        </ul>
      </section>

      <p>
        The exact onboarding JSON fields and validation limits are not
        included in the supplied assignment document.
      </p>
    </main>
  )
}

export default App