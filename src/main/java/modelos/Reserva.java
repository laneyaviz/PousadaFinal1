package modelos;

import java.time.LocalDate; 

public class Reserva {

    private int idReserva;
    private int idHospede;
    private int idQuarto;
    private LocalDate dataCheckin; 
    private LocalDate dataCheckout;
    private String status; 
    private int numAdultos;
    private int numCriancas;
    private double valorTotal;
    
    private Quartos quarto; 

    public Reserva() {}

    public Reserva(int idReserva, int idHospede, int idQuarto, LocalDate dataCheckin, LocalDate dataCheckout, String status, int numAdultos, int numCriancas, double valorTotal) {
        this.idReserva = idReserva;
        this.idHospede = idHospede;
        this.idQuarto = idQuarto;
        this.dataCheckin = dataCheckin;
        this.dataCheckout = dataCheckout;
        this.status = status;
        this.numAdultos = numAdultos;
        this.numCriancas = numCriancas;
        this.valorTotal = valorTotal;
    }
    
    public Reserva(int idHospede, int idQuarto, LocalDate dataCheckin, LocalDate dataCheckout, String status, int numAdultos, int numCriancas, double valorTotal) {
        this.idHospede = idHospede;
        this.idQuarto = idQuarto;
        this.dataCheckin = dataCheckin;
        this.dataCheckout = dataCheckout;
        this.status = status;
        this.numAdultos = numAdultos;
        this.numCriancas = numCriancas;
        this.valorTotal = valorTotal;
    }

    
    public int getIdReserva() { return idReserva; }
    public void setIdReserva (int idReserva) { this.idReserva = idReserva; }

    public int getIdHospede() { return idHospede; }
    public void setIdHospede (int idHospede) { this.idHospede = idHospede; }

    public int getIdQuarto() { return idQuarto; }
    public void setIdQuarto (int idQuarto) { this.idQuarto = idQuarto; }

    public LocalDate getDataCheckin() { return dataCheckin; }
    public void setDataCheckin (LocalDate dataCheckin) { this.dataCheckin = dataCheckin; }

    public LocalDate getDataCheckout() { return dataCheckout; }
    public void setDataCheckout (LocalDate dataCheckout) { this.dataCheckout = dataCheckout; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getNumAdultos() { return numAdultos; }
    public void setNumAdultos (int numAdultos) { this.numAdultos = numAdultos; }

    public int getNumCriancas() { return numCriancas; }
    public void setNumCriancas (int numCriancas) { this.numCriancas = numCriancas; }

    public double getValorTotal() { return valorTotal; }
    public void setValorTotal (double valorTotal) { this.valorTotal = valorTotal; }
    
    public Quartos getQuarto() { return quarto; }
    public void setQuarto(Quartos quarto) { this.quarto = quarto; }

    @Override
    public String toString() {
        return "Reserva [ID=" + idReserva + ", Hospede=" + idHospede + ", Quarto=" + idQuarto + ", Check-in=" + dataCheckin +
               ", Check-out=" + dataCheckout + ", Status=" + status + ", ValorTotal=" + valorTotal + "]";
    }
}