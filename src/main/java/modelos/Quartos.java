package modelos;

public class Quartos {
    
    private int idQuarto;
    private int numero;        
    private String tipo;        
    private double precoDiaria; 
    private String descricao;
    private int capacidadeMaxima; 
    private boolean disponivel;  

    public Quartos() {}

    public Quartos(int idQuarto, int numero, String tipo, double precoDiaria, String descricao, int capacidadeMaxima, boolean disponivel) {
        this.idQuarto = idQuarto;
        this.numero = numero; 
        this.tipo = tipo;
        this.precoDiaria = precoDiaria;
        this.descricao = descricao;
        this.capacidadeMaxima = capacidadeMaxima;
        this.disponivel = disponivel;
    }


    public int getIdQuarto() {
        return idQuarto;
    }

    public void setIdQuarto(int idQuarto) {
        this.idQuarto = idQuarto;
    }
    
    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public double getPrecoDiaria() {
        return precoDiaria;
    }

    public void setPrecoDiaria(double precoDiaria) {
        this.precoDiaria = precoDiaria;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getCapacidadeMaxima() {
        return capacidadeMaxima;
    }

    public void setCapacidadeMaxima(int capacidadeMaxima) {
        this.capacidadeMaxima = capacidadeMaxima;
    }

    public boolean isDisponivel() {
        return disponivel;
    }
   
    public void setDisponivel(boolean disponivel) {
        this.disponivel = disponivel;
    }
    
    @Override
    public String toString() {
        return "Quartos{" +
                "idQuarto=" + idQuarto +
                ", numero=" + numero +
                ", tipo='" + tipo + '\'' +
                ", precoDiaria=" + precoDiaria +
                ", capacidadeMaxima=" + capacidadeMaxima +
                ", disponivel=" + disponivel +
                '}';
    }
}