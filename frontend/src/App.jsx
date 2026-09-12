import { useState } from "react"

function App() {
  const [formData, setFormData] = useState({
    student_id: "",
    organization_id: "",
    student_name: "",
    onboarding_status: "pending",
  })

  const [message, setMessage] = useState("")

  const handleChange = (event) => {
    const { name, value } = event.target

    setFormData((current) => ({
      ...current,
      [name]: value,
    }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setMessage("Submitting...")

    try {
      const response = await fetch(
        "/api/student-onboarding/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(formData),
        },
      )

      const data = await response.json()

      if (!response.ok) {
        setMessage(`Validation failed: ${JSON.stringify(data)}`)
        return
      }

      setMessage(`Student onboarding accepted: ${data.student_id}`)
    } catch (error) {
      setMessage(`Request failed: ${error.message}`)
    }
  }

  return (
    <main>
      <h1>HabotConnect Student Onboarding</h1>

      <p>
        Student onboarding interface with Django REST Framework validation.
      </p>

      <form onSubmit={handleSubmit}>
        <label>
          Student ID
          <input
            name="student_id"
            value={formData.student_id}
            onChange={handleChange}
            required
          />
        </label>

        <br />

        <label>
          Organization ID
          <input
            name="organization_id"
            value={formData.organization_id}
            onChange={handleChange}
            required
          />
        </label>

        <br />

        <label>
          Student Name
          <input
            name="student_name"
            value={formData.student_name}
            onChange={handleChange}
            required
          />
        </label>

        <br />

        <label>
          Onboarding Status
          <select
            name="onboarding_status"
            value={formData.onboarding_status}
            onChange={handleChange}
          >
            <option value="pending">Pending</option>
            <option value="completed">Completed</option>
          </select>
        </label>

        <br />

        <button type="submit">Submit Onboarding</button>
      </form>

      <p>{message}</p>
    </main>
  )
}

export default App