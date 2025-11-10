package modelos;

import java.time.LocalDate;

public class Pagamentos {
    private int idPagamento;
    private int idReserva;
    private double valorTotal;
    private LocalDate dataPagamento;
    private String formaPagamento;
    private String status;

    public Pagamentos() {}

    public Pagamentos(int idReserva, double valorTotal, LocalDate dataPagamento, String formaPagamento, String status) {
        this.idReserva = idReserva;
        this.valorTotal = valorTotal;
        this.dataPagamento = dataPagamento;
        this.formaPagamento = formaPagamento;
        this.status = status;
    }

    public int getIdPagamento() {
        return idPagamento;
    }

    public void setIdPagamento(int idPagamento) {
        this.idPagamento = idPagamento;
    }

    public int getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public double getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(double valorTotal) {
        this.valorTotal = valorTotal;
    }

    public LocalDate getDataPagamento() {
        return dataPagamento;
    }

    public void setDataPagamento(LocalDate dataPagamento) {
        this.dataPagamento = dataPagamento;
    }

    public String getFormaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Pagamento [ID=" + idPagamento + ", Reserva=" + idReserva + ", Valor=" + valorTotal +
               ", Data=" + dataPagamento + ", Forma=" + formaPagamento + ", Status=" + status + "]";
    }
}

