package TestPackages.service;

import model.Appointment;
import service.validation.AppointmentDateHandler;
import service.validation.AppointmentTimeHandler;
import service.validation.RequiredAppointmentFieldsHandler;

import java.time.LocalDate;

public class AppointmentValidationTest {

/*
 * Test 1: Valid Appointment
 */
public static void testValidAppointment() {

        Appointment appointment = createValidAppointment();

        RequiredAppointmentFieldsHandler required
                = new RequiredAppointmentFieldsHandler();

        required.setNext(new AppointmentDateHandler())
                .setNext(new AppointmentTimeHandler());

        try {

            required.validate(appointment, null);

            System.out.println(
                    "TC01 - Valid Appointment: PASSED"
            );

        } catch (Exception e) {

            System.out.println(
                    "TC01 - Valid Appointment: FAILED - "
                    + e.getMessage()
            );
        }
    }


    /*
 * Test 2: Past Appointment Date
     */
    public static void testPastAppointmentDate() {

        Appointment appointment = createValidAppointment();

        appointment.setAppointmentDate(
                LocalDate.now().minusDays(1).toString()
        );

        RequiredAppointmentFieldsHandler required
                = new RequiredAppointmentFieldsHandler();

        required.setNext(new AppointmentDateHandler());

        try {

            required.validate(appointment, null);

            System.out.println(
                    "TC02 - Past Appointment Date: FAILED"
            );

        } catch (IllegalArgumentException e) {

            System.out.println(
                    "TC02 - Past Appointment Date: PASSED - "
                    + e.getMessage()
            );
        } catch (Exception e) {

            System.out.println(
                    "TC02 - Past Appointment Date: FAILED - "
                    + e.getMessage()
            );
        }
    }


    /*
 * Test 3: Invalid Appointment Time
     */
    public static void testInvalidAppointmentTime() {

        Appointment appointment = createValidAppointment();

        appointment.setAppointmentDate(
                LocalDate.now().plusDays(1).toString()
        );

        appointment.setAppointmentTime(
                "invalid-time"
        );

        RequiredAppointmentFieldsHandler required
                = new RequiredAppointmentFieldsHandler();

        required.setNext(new AppointmentDateHandler())
                .setNext(new AppointmentTimeHandler());

        try {

            required.validate(appointment, null);

            System.out.println(
                    "TC03 - Invalid Appointment Time: FAILED"
            );

        } catch (IllegalArgumentException e) {

            System.out.println(
                    "TC03 - Invalid Appointment Time: PASSED - "
                    + e.getMessage()
            );
        } catch (Exception e) {

            System.out.println(
                    "TC03 - Invalid Appointment Time: FAILED - "
                    + e.getMessage()
            );
        }
    }


    /*
 * Create valid test appointment
     */
    private static Appointment createValidAppointment() {

        Appointment appointment = new Appointment();

        appointment.setPatientId(1);
        appointment.setDoctorId(1);

        appointment.setPatientName(
                "Test Patient"
        );

        appointment.setPatientPhone(
                "0771234567"
        );

        appointment.setPatientAddress(
                "Colombo, Sri Lanka"
        );

        appointment.setTreatmentType(
                "Dental Checkup"
        );

        appointment.setAppointmentDate(
                LocalDate.now().plusDays(1).toString()
        );

        appointment.setAppointmentTime(
                "10:00"
        );

        return appointment;
    }


    /*
 * Main method for automated execution
     */
    public static void main(String[] args) {

        System.out.println(
                "======================================"
        );

        System.out.println(
                "Sunrise Dental Clinic"
        );

        System.out.println(
                "Automated Validation Testing"
        );

        System.out.println(
                "======================================"
        );

        testValidAppointment();

        testPastAppointmentDate();

        testInvalidAppointmentTime();

        System.out.println(
                "======================================"
        );

        System.out.println(
                "Automated Testing Completed"
        );

        System.out.println(
                "======================================"
        );
    }

}
