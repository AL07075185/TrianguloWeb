/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mx.webapp.geometria;

/**
 *
 * Modelo de un triángulo equilátero para el cálculo de área y perímetro.
 */
public class Triangulo {

    private double base;
    private double altura;

    /** Constructor vacío útil para JavaBeans. */
    public Triangulo() {
    }

    /** Constructor con valores numéricos directos. */
    public Triangulo(double base, double altura) {
        setBase(base);
        setAltura(altura);
    }

    /** Constructor que recibe valores de texto (capturados desde un formulario web). */
    public Triangulo(String base, String altura) {
        this(convertir(base, "base"), convertir(altura, "altura"));
    }

    /** Calcula el área: A = (b * h) / 2 */
    public double calcularArea() {
        return (base * altura) / 2;
    }

    /** Calcula el perímetro: P = 3 * b */
    public double calcularPerimetro() {
        return 3 * base;
    }

    /** Convierte texto a número decimal y valida que no esté vacío. */
    private static double convertir(String valor, String nombreCampo) {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException("El campo " + nombreCampo + " es obligatorio.");
        }
        try {
            return Double.parseDouble(valor.trim().replace(',', '.'));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("El campo " + nombreCampo + " debe ser un numero valido.");
        }
    }

    public double getBase() {
        return base;
    }

    public void setBase(double base) {
        if (base <= 0 || Double.isNaN(base) || Double.isInfinite(base)) {
            throw new IllegalArgumentException("La base debe ser un numero mayor que cero.");
        }
        this.base = base;
    }

    public double getAltura() {
        return altura;
    }

    public void setAltura(double altura) {
        if (altura <= 0 || Double.isNaN(altura) || Double.isInfinite(altura)) {
            throw new IllegalArgumentException("La altura debe ser un numero mayor que cero.");
        }
        this.altura = altura;
    }
}