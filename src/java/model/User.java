package model;

import java.sql.Date;

public class User {

    private int id;

    private String firstName;
    private String lastName;

    private String email;
    private String phone;

    private String password;
    private String role;

    private Date dateOfBirth;
    private String gender;

    private String medicalRegistrationNo;
    private String specialization;
    private String qualification;
    private Integer experience;

    private String employeeId;
    private String department;
    private String cashierShift;
    private String posId;


    public User() {
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }


    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }


    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }


    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }


    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }


    public String getMedicalRegistrationNo() {
        return medicalRegistrationNo;
    }

    public void setMedicalRegistrationNo(
            String medicalRegistrationNo) {

        this.medicalRegistrationNo =
                medicalRegistrationNo;
    }


    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(
            String specialization) {

        this.specialization =
                specialization;
    }


    public String getQualification() {
        return qualification;
    }

    public void setQualification(
            String qualification) {

        this.qualification =
                qualification;
    }


    public Integer getExperience() {
        return experience;
    }

    public void setExperience(Integer experience) {
        this.experience = experience;
    }


    public String getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }


    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }


    public String getCashierShift() {
        return cashierShift;
    }

    public void setCashierShift(String cashierShift) {
        this.cashierShift = cashierShift;
    }


    public String getPosId() {
        return posId;
    }

    public void setPosId(String posId) {
        this.posId = posId;
    }
}